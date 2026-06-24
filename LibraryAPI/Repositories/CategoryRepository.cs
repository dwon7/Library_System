using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;

namespace LibraryAPI.Repositories;

public class CategoryRepository : Repository<Category>, ICategoryRepository
{
    private readonly IMongoCollection<Category> _categories;

    public CategoryRepository(MongoDbContext ctx)
        : base(ctx.Categories) => _categories = ctx.Categories;

    public async Task<Category?> GetByMaDanhMucAsync(string maDanhMuc) =>
        await _categories
            .Find(c => c.MaDanhMuc == maDanhMuc && !c.IsDeleted)
            .FirstOrDefaultAsync();

    public async Task<List<Category>> GetAllActiveAsync() =>
        await _categories
            .Find(c => !c.IsDeleted)
            .SortBy(c => c.TenDanhMuc)
            .ToListAsync();
}
