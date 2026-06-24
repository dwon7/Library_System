using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;

namespace LibraryAPI.Repositories;

public class StockTransactionRepository
    : Repository<StockTransaction>, IStockTransactionRepository
{
    private readonly IMongoCollection<StockTransaction> _transactions;

    public StockTransactionRepository(MongoDbContext ctx)
        : base(ctx.StockTransactions) => _transactions = ctx.StockTransactions;

    public async Task<List<StockTransaction>> GetByLoaiPhieuAsync(int loaiPhieu) =>
        await _transactions
            .Find(t => t.LoaiPhieu == loaiPhieu && !t.IsDeleted)
            .SortByDescending(t => t.NgayThucHien)
            .ToListAsync();

    public async Task<List<StockTransaction>> GetByDateRangeAsync(
        DateTime from, DateTime to) =>
        await _transactions
            .Find(t => t.NgayThucHien >= from
                    && t.NgayThucHien <= to
                    && !t.IsDeleted)
            .SortByDescending(t => t.NgayThucHien)
            .ToListAsync();

    public async Task<List<StockTransaction>> GetBySachIdAsync(string sachId) =>
        await _transactions
            .Find(t => t.ChiTietGiaoDich.Any(d => d.SachId == sachId)
                    && !t.IsDeleted)
            .ToListAsync();
}
