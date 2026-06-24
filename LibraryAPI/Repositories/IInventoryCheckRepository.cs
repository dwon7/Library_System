using LibraryAPI.Domain.Entities;

namespace LibraryAPI.Repositories;

public interface IInventoryCheckRepository : IRepository<InventoryCheck>
{
    Task<List<InventoryCheck>> GetByTrangThaiAsync(int trangThai);
    Task<InventoryCheck?> GetByMaPhieuAsync(string maPhieu);
    Task<List<InventoryCheck>> GetByDateRangeAsync(DateTime from, DateTime to);
}
