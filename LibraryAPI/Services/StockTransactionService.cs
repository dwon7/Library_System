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
    private readonly MongoDbContext _ctx; // Dùng cho Transaction

    public StockTransactionService(
        IStockTransactionRepository transRepo,
        MongoDbContext ctx)
    {
        _transRepo = transRepo;
        _ctx = ctx;
    }

    public async Task<List<StockTransactionResponseDto>> GetAllAsync()
    {
        var list = await _transRepo.GetAllAsync();
        return list.Select(MapToDto).ToList();
    }

    public async Task<StockTransactionResponseDto?> GetByIdAsync(string id)
    {
        var t = await _transRepo.GetByIdAsync(id);
        return t == null ? null : MapToDto(t);
    }

    /// <summary>
    /// Nhập kho — MongoDB Transaction:
    /// 1. Tạo phiếu nhập trong stock_transactions
    /// 2. Tăng SoLuongCon + TongSoLuong trong books
    /// </summary>
    public async Task<(bool ok, string message, StockTransactionResponseDto? data)>
        CreateImportAsync(StockTransactionCreateDto dto, string userId)
    {
        using var session = await _ctx.Client.StartSessionAsync();
        session.StartTransaction();
        try
        {
            var transaction = BuildTransaction(dto, TransactionType.Import, userId);

            // Tăng số lượng sách trong kho
            foreach (var item in transaction.ChiTietGiaoDich)
            {
                var update = Builders<Book>.Update
                    .Inc(b => b.SoLuongCon, item.SoLuong)
                    .Inc(b => b.TongSoLuong, item.SoLuong);
                var result = await _ctx.Books.UpdateOneAsync(
                    session,
                    b => b.Id == item.SachId && !b.IsDeleted,
                    update);

                if (result.MatchedCount == 0)
                {
                    await session.AbortTransactionAsync();
                    return (false, $"Không tìm thấy sách ID: {item.SachId}", null);
                }
            }

            await _ctx.StockTransactions.InsertOneAsync(session, transaction);
            await session.CommitTransactionAsync();

            return (true, "Nhập kho thành công", MapToDto(transaction));
        }
        catch (Exception ex)
        {
            await session.AbortTransactionAsync();
            return (false, $"Lỗi giao dịch: {ex.Message}", null);
        }
    }

    /// <summary>
    /// Xuất kho — MongoDB Transaction:
    /// 1. Kiểm tra SoLuongCon đủ không
    /// 2. Tạo phiếu xuất trong stock_transactions
    /// 3. Giảm SoLuongCon trong books
    /// </summary>
    public async Task<(bool ok, string message, StockTransactionResponseDto? data)>
        CreateExportAsync(StockTransactionCreateDto dto, string userId)
    {
        using var session = await _ctx.Client.StartSessionAsync();
        session.StartTransaction();
        try
        {
            var transaction = BuildTransaction(dto, TransactionType.Export, userId);

            foreach (var item in transaction.ChiTietGiaoDich)
            {
                var filter = Builders<Book>.Filter.And(
                    Builders<Book>.Filter.Eq(b => b.Id, item.SachId),
                    Builders<Book>.Filter.Gte(b => b.SoLuongCon, item.SoLuong),
                    Builders<Book>.Filter.Eq(b => b.IsDeleted, false));

                var update = Builders<Book>.Update
                    .Inc(b => b.SoLuongCon, -item.SoLuong)
                    .Inc(b => b.TongSoLuong, -item.SoLuong);

                var result = await _ctx.Books.FindOneAndUpdateAsync(
                    session, filter, update);

                if (result == null)
                {
                    await session.AbortTransactionAsync();
                    return (false,
                        $"Sách ID {item.SachId} không đủ số lượng để xuất", null);
                }
            }

            await _ctx.StockTransactions.InsertOneAsync(session, transaction);
            await session.CommitTransactionAsync();

            return (true, "Xuất kho thành công", MapToDto(transaction));
        }
        catch (Exception ex)
        {
            await session.AbortTransactionAsync();
            return (false, $"Lỗi giao dịch: {ex.Message}", null);
        }
    }

    public async Task<List<StockTransactionResponseDto>> GetByLoaiPhieuAsync(
        int loaiPhieu)
    {
        var list = await _transRepo.GetByLoaiPhieuAsync(loaiPhieu);
        return list.Select(MapToDto).ToList();
    }

    public async Task<List<StockTransactionResponseDto>> GetByDateRangeAsync(
        DateTime from, DateTime to)
    {
        var list = await _transRepo.GetByDateRangeAsync(from, to);
        return list.Select(MapToDto).ToList();
    }

    private static StockTransaction BuildTransaction(
        StockTransactionCreateDto dto, int loaiPhieu, string userId)
    {
        var details = dto.ChiTietGiaoDich.Select(d => new TransactionDetail
        {
            SachId = d.SachId,
            SoLuong = d.SoLuong,
            DonGia = d.DonGia,
            ThanhTien = d.SoLuong * d.DonGia
        }).ToList();

        return new StockTransaction
        {
            MaGiaoDich = dto.MaGiaoDich,
            LoaiPhieu = loaiPhieu,
            NgayThucHien = dto.NgayThucHien,
            CanBoPhuTrach = dto.CanBoPhuTrach,
            CanBoId = dto.CanBoId,
            DoiTac = new DoiTacInfo
            {
                TenDoiTac = dto.TenDoiTac,
                MaSoThueHoacMssv = dto.MaSoThueHoacMssv
            },
            ChiTietGiaoDich = details,
            TongTien = details.Sum(d => d.ThanhTien),
            GhiChu = dto.GhiChu,
            CreatedBy = userId
        };
    }

    private static StockTransactionResponseDto MapToDto(StockTransaction t) => new()
    {
        Id = t.Id!,
        MaGiaoDich = t.MaGiaoDich,
        LoaiPhieu = t.LoaiPhieu,
        LoaiPhieuText = t.LoaiPhieu == TransactionType.Import ? "Nhập kho" : "Xuất kho",
        NgayThucHien = t.NgayThucHien,
        CanBoPhuTrach = t.CanBoPhuTrach,
        TenDoiTac = t.DoiTac.TenDoiTac,
        TongTien = t.TongTien,
        GhiChu = t.GhiChu,
        SoLuongDauSach = t.ChiTietGiaoDich.Count,
        TongSoLuongSach = t.ChiTietGiaoDich.Sum(d => d.SoLuong)
    };
}
