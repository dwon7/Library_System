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
    public InventoryCheckService(IInventoryCheckRepository inventoryRepo, MongoDbContext ctx)
    {
        _inventoryRepo = inventoryRepo;
        _ctx = ctx;
    }

    public async Task<InventoryCheckResponseDto?> GetByIdAsync(string auditId)
    {
        var inv = await _ctx.InventoryChecks
            .Find(i => i.MaPhieuKiemKe == auditId && !i.IsDeleted)
            .FirstOrDefaultAsync();
        return inv == null ? null : MapToDto(inv);
    }

    public async Task<InventoryCheckResponseDto> CreateAsync(InventoryCheckCreateDto dto, string userId)
    {
        var inventory = new InventoryCheck
        {
            MaPhieuKiemKe = dto.AuditId,
            NgayKiemKe = dto.AuditDate ?? DateTime.UtcNow,
            HoiDongKiemKe = dto.AuditBoard.Select(h => new KiemKeMember
            {
                HoTen = h.FullName,
                VaiTro = h.Role
            }).ToList(),
            TrangThai = InventoryStatus.InProgress,
            KetQuaChiTiet = dto.AuditDetails.Select(k => new InventoryDetail
            {
                SachId = k.BookId,
                SoLuong = k.Quantity,
                TinhTrangSach = k.ConditionType
            }).ToList(),
            TongSoLuongKiemKe = dto.TotalAuditedQuantity ?? dto.AuditDetails.Sum(k => k.Quantity),
            GhiChu = dto.Notes,
            CreatedBy = userId
        };
        await _inventoryRepo.CreateAsync(inventory);
        return MapToDto(inventory);
    }

    public async Task<(bool ok, string message)> CompleteInventoryAsync(string id, string userId)
    {
        var inventory = await _inventoryRepo.GetByIdAsync(id);
        if (inventory == null) return (false, "Không tìm thấy phiếu kiểm kê");
        if (inventory.TrangThai == InventoryStatus.Completed)
            return (false, "Phiếu kiểm kê đã hoàn thành trước đó");

        var sachGroups = inventory.KetQuaChiTiet
            .GroupBy(k => k.SachId)
            .Select(g => new
            {
                SachId = g.Key,
                SoLuongConDung = g.Where(k => k.TinhTrangSach == BookCondition.Good).Sum(k => k.SoLuong)
            });
        foreach (var group in sachGroups)
        {
            var upd = Builders<Book>.Update
                .Set(b => b.SoLuongCon, group.SoLuongConDung)
                .Set(b => b.UpdatedAt, DateTime.UtcNow)
                .Set(b => b.UpdatedBy, userId);
            await _ctx.Books.UpdateOneAsync(b => b.Id == group.SachId && !b.IsDeleted, upd);
        }
        var invUpd = Builders<InventoryCheck>.Update
            .Set(i => i.TrangThai, InventoryStatus.Completed)
            .Set(i => i.UpdatedAt, DateTime.UtcNow)
            .Set(i => i.UpdatedBy, userId);
        await _ctx.InventoryChecks.UpdateOneAsync(i => i.Id == id, invUpd);
        return (true, "Hoàn thành kiểm kê, đã cập nhật số lượng sách");
    }

    public async Task<int> GetCountByStatusAsync(int status)
    {
        var filter = status == 0
            ? Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false)
            : Builders<InventoryCheck>.Filter.And(
                Builders<InventoryCheck>.Filter.Eq(i => i.TrangThai, status),
                Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false));
        return (int)await _ctx.InventoryChecks.CountDocumentsAsync(filter);
    }

    public async Task<List<InventoryCheckResponseDto>> GetListByStatusAsync(int status)
    {
        var list = status == 0
            ? await _inventoryRepo.GetAllAsync()
            : await _inventoryRepo.GetByTrangThaiAsync(status);
        return list.Select(MapToDto).ToList();
    }

    public async Task<string> GenerateAuditIdAsync()
    {
        var count = await _ctx.InventoryChecks.CountDocumentsAsync(_ => true);
        return $"KK-{(count + 1):D3}";
    }

    public async Task<InventoryStatDto> GetStatisticsAsync(string inventoryId)
    {
        var inv = await _inventoryRepo.GetByIdAsync(inventoryId);
        if (inv == null) return new InventoryStatDto();
        return new InventoryStatDto
        {
            AuditId = inv.MaPhieuKiemKe,
            TotalQuantity = inv.TongSoLuongKiemKe,
            GoodQuantity = inv.KetQuaChiTiet.Where(k => k.TinhTrangSach == BookCondition.Good).Sum(k => k.SoLuong),
            DamagedQuantity = inv.KetQuaChiTiet.Where(k => k.TinhTrangSach == BookCondition.Damaged).Sum(k => k.SoLuong),
            LostQuantity = inv.KetQuaChiTiet.Where(k => k.TinhTrangSach == BookCondition.Lost).Sum(k => k.SoLuong),
            UniqueBookCount = inv.KetQuaChiTiet.Select(k => k.SachId).Distinct().Count()
        };
    }

    private static InventoryCheckResponseDto MapToDto(InventoryCheck i) => new()
    {
        AuditId = i.MaPhieuKiemKe,
        AuditDate = i.NgayKiemKe,
        AuditBoard = i.HoiDongKiemKe.Select(h => new AuditBoardMemberResponseDto
        {
            FullName = h.HoTen,
            Role = h.VaiTro
        }).ToList(),
        Status = i.TrangThai,
        AuditDetails = i.KetQuaChiTiet.Select(k => new AuditDetailResponseDto
        {
            BookId = k.SachId,
            Quantity = k.SoLuong,
            ConditionType = k.TinhTrangSach
        }).ToList(),
        TotalAuditedQuantity = i.TongSoLuongKiemKe,
        Notes = i.GhiChu
    };
}
