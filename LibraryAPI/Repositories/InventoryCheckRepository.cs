using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;

namespace LibraryAPI.Repositories;

public class InventoryCheckRepository
    : Repository<InventoryCheck>, IInventoryCheckRepository
{
    private readonly IMongoCollection<InventoryCheck> _inventories;

    public InventoryCheckRepository(MongoDbContext ctx)
        : base(ctx.InventoryChecks) => _inventories = ctx.InventoryChecks;

    public async Task<List<InventoryCheck>> GetByTrangThaiAsync(int trangThai) =>
        await _inventories
            .Find(i => i.TrangThai == trangThai && !i.IsDeleted)
            .SortByDescending(i => i.NgayKiemKe)
            .ToListAsync();

    public async Task<InventoryCheck?> GetByMaPhieuAsync(string maPhieu) =>
        await _inventories
            .Find(i => i.MaPhieuKiemKe == maPhieu && !i.IsDeleted)
            .FirstOrDefaultAsync();

    public async Task<List<InventoryCheck>> GetByDateRangeAsync(
        DateTime from, DateTime to) =>
        await _inventories
            .Find(i => i.NgayKiemKe >= from
                    && i.NgayKiemKe <= to
                    && !i.IsDeleted)
            .SortByDescending(i => i.NgayKiemKe)
            .ToListAsync();
}
