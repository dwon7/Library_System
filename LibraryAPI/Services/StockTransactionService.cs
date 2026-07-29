using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.StockTransaction;
using LibraryAPI.Infrastructure;
using LibraryAPI.Repositories;
using MongoDB.Driver;
namespace LibraryAPI.Services;
public class StockTransactionService : IStockTransactionService
{
    private readonly IStockTransactionRepository _transRepo;
    private readonly MongoDbContext _ctx;
    public StockTransactionService(IStockTransactionRepository transRepo, MongoDbContext ctx)
    {
        _transRepo = transRepo;
        _ctx = ctx;
    }

    public async Task<StockTransactionResponseDto?> GetByIdAsync(string ledgerId)
    {
        var t = await _ctx.StockTransactions
            .Find(x => x.MaGiaoDich == ledgerId && !x.IsDeleted)
            .FirstOrDefaultAsync();
        return t == null ? null : MapToDto(t);
    }

    public async Task<int> GetCountByTypeAsync(int ledgerType)
    {
        var filter = ledgerType == 0
            ? Builders<StockTransaction>.Filter.Eq(t => t.IsDeleted, false)
            : Builders<StockTransaction>.Filter.And(
                Builders<StockTransaction>.Filter.Eq(t => t.LoaiPhieu, ledgerType),
                Builders<StockTransaction>.Filter.Eq(t => t.IsDeleted, false));
        return (int)await _ctx.StockTransactions.CountDocumentsAsync(filter);
    }

    public async Task<List<StockTransactionResponseDto>> GetListByTypeAsync(int ledgerType)
    {
        var list = ledgerType == 0
            ? await _transRepo.GetAllAsync()
            : await _transRepo.GetByLoaiPhieuAsync(ledgerType);
        return list.Select(MapToDto).ToList();
    }

    public async Task<string> GenerateLedgerIdAsync(int ledgerType)
    {
        var prefix = ledgerType == TransactionType.Export ? "XK" : "NK";
        var count = await _ctx.StockTransactions.CountDocumentsAsync(
            t => t.LoaiPhieu == ledgerType);
        return $"{prefix}-{(count + 1):D3}";
    }

    public async Task<bool> DeleteAsync(string ledgerId)
    {
        var update = Builders<StockTransaction>.Update
            .Set(t => t.IsDeleted, true)
            .Set(t => t.UpdatedAt, DateTime.UtcNow);
        var result = await _ctx.StockTransactions.UpdateOneAsync(
            t => t.MaGiaoDich == ledgerId && !t.IsDeleted, update);
        return result.ModifiedCount > 0;
    }

    public async Task<(bool ok, string message, StockTransactionResponseDto? data)> CreateImportAsync(StockTransactionCreateDto dto, string userId)
    {
        var transaction = BuildEntity(dto, TransactionType.Import, userId);
        foreach (var item in transaction.ChiTietGiaoDich)
        {
            var upd = Builders<Book>.Update
                .Inc(b => b.SoLuongCon, item.SoLuong)
                .Inc(b => b.TongSoLuong, item.SoLuong);
            var result = await _ctx.Books.UpdateOneAsync(
                b => b.Id == item.SachId && !b.IsDeleted, upd);
            if (result.MatchedCount == 0)
                return (false, $"Không tìm thấy sách ID: {item.SachId}", null);
        }
        await _ctx.StockTransactions.InsertOneAsync(transaction);
        return (true, "Nhập kho thành công", MapToDto(transaction));
    }

    public async Task<(bool ok, string message, StockTransactionResponseDto? data)> CreateExportAsync(StockTransactionCreateDto dto, string userId)
    {
        // Pre-check all books have sufficient stock before modifying anything
        foreach (var item in dto.LedgerDetails)
        {
            var book = await _ctx.Books
                .Find(b => b.Id == item.BookId && !b.IsDeleted)
                .FirstOrDefaultAsync();
            if (book == null || book.SoLuongCon < item.Quantity)
                return (false, $"Sách ID {item.BookId} không đủ số lượng để xuất", null);
        }
        var transaction = BuildEntity(dto, TransactionType.Export, userId);
        foreach (var item in transaction.ChiTietGiaoDich)
        {
            var filter = Builders<Book>.Filter.And(
                Builders<Book>.Filter.Eq(b => b.Id, item.SachId),
                Builders<Book>.Filter.Gte(b => b.SoLuongCon, item.SoLuong),
                Builders<Book>.Filter.Eq(b => b.IsDeleted, false));
            var upd = Builders<Book>.Update
                .Inc(b => b.SoLuongCon, -item.SoLuong)
                .Inc(b => b.TongSoLuong, -item.SoLuong);
            var result = await _ctx.Books.FindOneAndUpdateAsync(filter, upd);
            if (result == null)
                return (false, $"Sách ID {item.SachId} không đủ số lượng để xuất", null);
        }
        await _ctx.StockTransactions.InsertOneAsync(transaction);
        return (true, "Xuất kho thành công", MapToDto(transaction));
    }

    private static StockTransaction BuildEntity(StockTransactionCreateDto dto, int loaiPhieu, string userId)
    {
        var details = dto.LedgerDetails.Select(d => new TransactionDetail
        {
            SachId = d.BookId,
            SoLuong = d.Quantity,
            DonGia = d.UnitPrice,
            ThanhTien = d.TotalAmount > 0 ? d.TotalAmount : d.Quantity * d.UnitPrice
        }).ToList();
        return new StockTransaction
        {
            MaGiaoDich = dto.LedgerId,
            LoaiPhieu = loaiPhieu,
            NgayThucHien = dto.TransactionDate ?? DateTime.UtcNow,
            CanBoPhuTrach = dto.StaffInCharge,
            DoiTac = new DoiTacInfo
            {
                TenDoiTac = dto.Partner.PartnerName,
                MaSoThueHoacMssv = dto.Partner.TaxOrStudentId
            },
            ChiTietGiaoDich = details,
            TongTien = dto.GrandTotal ?? details.Sum(d => d.ThanhTien),
            GhiChu = dto.Notes,
            CreatedBy = userId
        };
    }

    private static StockTransactionResponseDto MapToDto(StockTransaction t) => new()
    {
        LedgerId = t.MaGiaoDich,
        LedgerType = t.LoaiPhieu,
        TransactionDate = t.NgayThucHien,
        StaffInCharge = t.CanBoPhuTrach,
        Partner = new PartnerResponseDto
        {
            PartnerName = t.DoiTac.TenDoiTac,
            TaxOrStudentId = t.DoiTac.MaSoThueHoacMssv
        },
        LedgerDetails = t.ChiTietGiaoDich.Select(d => new LedgerDetailResponseDto
        {
            BookId = d.SachId,
            Quantity = d.SoLuong,
            UnitPrice = d.DonGia,
            TotalAmount = d.ThanhTien
        }).ToList(),
        GrandTotal = t.TongTien,
        Notes = t.GhiChu
    };
}
