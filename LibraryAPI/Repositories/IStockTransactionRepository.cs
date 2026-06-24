using LibraryAPI.Domain.Entities;

namespace LibraryAPI.Repositories;

public interface IStockTransactionRepository : IRepository<StockTransaction>
{
    Task<List<StockTransaction>> GetByLoaiPhieuAsync(int loaiPhieu);
    Task<List<StockTransaction>> GetByDateRangeAsync(DateTime from, DateTime to);
    Task<List<StockTransaction>> GetBySachIdAsync(string sachId);
}
