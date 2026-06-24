using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Infrastructure;
using LibraryAPI.Repositories;
using MongoDB.Driver;

namespace LibraryAPI.Services;

public class InventoryCheckService : IInventoryCheckService
{
    private readonly IInventoryCheckRepository _inventoryRepo;
    private readonly MongoDbContext _ctx;

    public InventoryCheckService(
        IInventoryCheckRepository inventoryRepo,
        MongoDbContext ctx)
    {
        _inventoryRepo = inventoryRepo;
        _ctx = ctx;
    }

    public async Task<List<InventoryCheckResponseDto>> GetAllAsync()
    {
        var list = await _inventoryRepo.GetAllAsync();
        return list.Select(MapToDto).ToList();
    }

    public async Task<InventoryCheckResponseDto?> GetByIdAsync(string id)
    {
        var inv = await _inventoryRepo.GetByIdAsync(id);
        return inv == null ? null : MapToDto(inv);
    }

    public async Task<InventoryCheckResponseDto> CreateAsync(
        InventoryCheckCreateDto dto, string userId)
    {
        var inventory = new InventoryCheck
        {
            MaPhieuKiemKe = dto.MaPhieuKiemKe,
            NgayKiemKe = dto.NgayKiemKe,
            HoiDongKiemKe = dto.HoiDong.Select(h => new KiemKeMember
            {
                HoTen = h.HoTen,
                VaiTro = h.VaiTro
            }).ToList(),
            TrangThai = InventoryStatus.InProgress,
            KetQuaChiTiet = dto.KetQua.Select(k => new InventoryDetail
            {
                SachId = k.SachId,
                SoLuong = k.SoLuong,
                TinhTrangSach = k.TinhTrangSach
            }).ToList(),
            TongSoLuongKiemKe = dto.KetQua.Sum(k => k.SoLuong),
            GhiChu = dto.GhiChu,
            CreatedBy = userId
        };

        await _inventoryRepo.CreateAsync(inventory);
        return MapToDto(inventory);
    }

    /// <summary>
    /// Hoàn thành kiểm kê — MongoDB Transaction:
    /// 1. Cập nhật trạng thái phiếu = Hoàn thành
    /// 2. Cập nhật SoLuongCon trong books theo kết quả thực tế
    /// </summary>
    public async Task<(bool ok, string message)> CompleteInventoryAsync(
        string id, string userId)
    {
        var inventory = await _inventoryRepo.GetByIdAsync(id);
        if (inventory == null) return (false, "Không tìm thấy phiếu kiểm kê");
        if (inventory.TrangThai == InventoryStatus.Completed)
            return (false, "Phiếu kiểm kê đã hoàn thành trước đó");

        using var session = await _ctx.Client.StartSessionAsync();
        session.StartTransaction();
        try
        {
            // Nhóm kết quả theo sach_id, tính tổng số lượng còn dùng được
            var sachGroups = inventory.KetQuaChiTiet
                .GroupBy(k => k.SachId)
                .Select(g => new
                {
                    SachId = g.Key,
                    SoLuongConDung = g
                        .Where(k => k.TinhTrangSach == BookCondition.Good)
                        .Sum(k => k.SoLuong)
                });

            // Cập nhật SoLuongCon trong books theo thực tế kiểm kê
            foreach (var group in sachGroups)
            {
                var update = Builders<Book>.Update
                    .Set(b => b.SoLuongCon, group.SoLuongConDung)
                    .Set(b => b.UpdatedAt, DateTime.UtcNow)
                    .Set(b => b.UpdatedBy, userId);

                await _ctx.Books.UpdateOneAsync(
                    session,
                    b => b.Id == group.SachId && !b.IsDeleted,
                    update);
            }

            // Cập nhật trạng thái phiếu kiểm kê
            var invUpdate = Builders<InventoryCheck>.Update
                .Set(i => i.TrangThai, InventoryStatus.Completed)
                .Set(i => i.UpdatedAt, DateTime.UtcNow)
                .Set(i => i.UpdatedBy, userId);

            await _ctx.InventoryChecks.UpdateOneAsync(
                session, i => i.Id == id, invUpdate);

            await session.CommitTransactionAsync();
            return (true, "Hoàn thành kiểm kê, đã cập nhật số lượng sách");
        }
        catch (Exception ex)
        {
            await session.AbortTransactionAsync();
            return (false, $"Lỗi giao dịch: {ex.Message}");
        }
    }

    public async Task<List<InventoryCheckResponseDto>> GetByTrangThaiAsync(
        int trangThai)
    {
        var list = await _inventoryRepo.GetByTrangThaiAsync(trangThai);
        return list.Select(MapToDto).ToList();
    }

    public async Task<InventoryStatDto> GetStatisticsAsync(string inventoryId)
    {
        var inv = await _inventoryRepo.GetByIdAsync(inventoryId);
        if (inv == null) return new InventoryStatDto();

        return new InventoryStatDto
        {
            MaPhieuKiemKe = inv.MaPhieuKiemKe,
            TongSoLuong = inv.TongSoLuongKiemKe,
            SoLuongConDung = inv.KetQuaChiTiet
                .Where(k => k.TinhTrangSach == BookCondition.Good)
                .Sum(k => k.SoLuong),
            SoLuongHong = inv.KetQuaChiTiet
                .Where(k => k.TinhTrangSach == BookCondition.Damaged)
                .Sum(k => k.SoLuong),
            SoLuongMat = inv.KetQuaChiTiet
                .Where(k => k.TinhTrangSach == BookCondition.Lost)
                .Sum(k => k.SoLuong),
            SoDauSachKiemKe = inv.KetQuaChiTiet
                .Select(k => k.SachId).Distinct().Count()
        };
    }

    private static InventoryCheckResponseDto MapToDto(InventoryCheck i) => new()
    {
        Id = i.Id!,
        MaPhieuKiemKe = i.MaPhieuKiemKe,
        NgayKiemKe = i.NgayKiemKe,
        TrangThai = i.TrangThai,
        TrangThaiText = i.TrangThai == InventoryStatus.Completed
            ? "Đã hoàn thành" : "Chưa hoàn thành",
        TongSoLuongKiemKe = i.TongSoLuongKiemKe,
        SoThanhVienHoiDong = i.HoiDongKiemKe.Count,
        GhiChu = i.GhiChu,
        CreatedAt = i.CreatedAt
    };
}
