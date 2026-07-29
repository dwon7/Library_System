using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Infrastructure;
using LibraryAPI.Repositories;
using MongoDB.Bson;
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
                TinhTrangSach = BookCondition.NotInventoried  // luôn khởi tạo là 4, chờ quét QR
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

    public async Task<int[]> GetAuditProgressAsync(string auditId)
    {
        var inv = await _ctx.InventoryChecks
            .Find(i => i.MaPhieuKiemKe == auditId && !i.IsDeleted)
            .FirstOrDefaultAsync();
        if (inv == null) return new[] { 0, 0 };

        var distinctBooks = inv.KetQuaChiTiet.GroupBy(k => k.SachId).ToList();
        var totalCount = distinctBooks.Count;
        var scannedCount = distinctBooks
            .Count(g => g.Any(k => k.TinhTrangSach != BookCondition.NotInventoried));
        return new[] { scannedCount, totalCount };
    }

    public async Task<int> ScanQRAsync(string auditId, string qrValue)
    {
        var book = await _ctx.Books
            .Find(b => b.QrCode == qrValue && !b.IsDeleted)
            .FirstOrDefaultAsync();
        if (book?.Id == null) return 2;

        var docFilter = Builders<InventoryCheck>.Filter.And(
            Builders<InventoryCheck>.Filter.Eq(i => i.MaPhieuKiemKe, auditId),
            Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false),
            Builders<InventoryCheck>.Filter.ElemMatch(
                i => i.KetQuaChiTiet,
                k => k.SachId == book.Id && k.TinhTrangSach == BookCondition.NotInventoried));

        var arrayFilter = new BsonDocumentArrayFilterDefinition<BsonDocument>(
            new BsonDocument
            {
                { "elem.sach_id", ObjectId.Parse(book.Id) },
                { "elem.tinh_trang_sach", BookCondition.NotInventoried }
            });

        var update = Builders<InventoryCheck>.Update
            .Set("ket_qua_chi_tiet.$[elem].tinh_trang_sach", BookCondition.Good)
            .Set(i => i.UpdatedAt, DateTime.UtcNow);

        var result = await _ctx.InventoryChecks.UpdateOneAsync(
            docFilter, update, new UpdateOptions { ArrayFilters = new[] { arrayFilter } });
        return result.ModifiedCount > 0 ? 1 : 2;
    }

    public async Task<bool> UpdateBookConditionAsync(string auditId, string bookId, int conditionType)
    {
        var docFilter = Builders<InventoryCheck>.Filter.And(
            Builders<InventoryCheck>.Filter.Eq(i => i.MaPhieuKiemKe, auditId),
            Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false));

        var arrayFilter = new BsonDocumentArrayFilterDefinition<BsonDocument>(
            new BsonDocument("elem.sach_id", ObjectId.Parse(bookId)));

        var update = Builders<InventoryCheck>.Update
            .Set("ket_qua_chi_tiet.$[elem].tinh_trang_sach", conditionType)
            .Set(i => i.UpdatedAt, DateTime.UtcNow);

        var result = await _ctx.InventoryChecks.UpdateOneAsync(
            docFilter, update, new UpdateOptions { ArrayFilters = new[] { arrayFilter } });
        return result.ModifiedCount > 0;
    }

    public async Task<List<AuditDetailResponseDto>> GetBooksByStatusAsync(string auditId, int status)
    {
        var inv = await _ctx.InventoryChecks
            .Find(i => i.MaPhieuKiemKe == auditId && !i.IsDeleted)
            .FirstOrDefaultAsync();
        if (inv == null) return new List<AuditDetailResponseDto>();

        // status=1: đã kiểm kê (tinh_trang != 4), status=2: chưa kiểm kê (tinh_trang == 4)
        var filtered = status == 1
            ? inv.KetQuaChiTiet.Where(k => k.TinhTrangSach != BookCondition.NotInventoried)
            : inv.KetQuaChiTiet.Where(k => k.TinhTrangSach == BookCondition.NotInventoried);

        return filtered.Select(k => new AuditDetailResponseDto
        {
            BookId = k.SachId,
            Quantity = k.SoLuong,
            ConditionType = k.TinhTrangSach
        }).ToList();
    }

    public async Task<bool> DeleteAuditAsync(string auditId)
    {
        var update = Builders<InventoryCheck>.Update
            .Set(i => i.IsDeleted, true)
            .Set(i => i.UpdatedAt, DateTime.UtcNow);
        var result = await _ctx.InventoryChecks.UpdateOneAsync(
            i => i.MaPhieuKiemKe == auditId && !i.IsDeleted, update);
        return result.ModifiedCount > 0;
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
