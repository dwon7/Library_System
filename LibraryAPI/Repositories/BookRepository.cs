using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Bson;
using MongoDB.Driver;
namespace LibraryAPI.Repositories;
public class BookRepository : Repository<Book>, IBookRepository
{
    private readonly IMongoCollection<Book> _books;
    public BookRepository(MongoDbContext ctx) : base(ctx.Books) => _books = ctx.Books;

    public async Task<(List<Book> items, long total)> SearchAsync(string? keyword, string? categoryId, int page, int pageSize)
    {
        var b = Builders<Book>.Filter;
        var filter = b.Eq(x => x.IsDeleted, false);
        if (!string.IsNullOrWhiteSpace(keyword))
            filter &= b.Or(
                b.Regex(x => x.TenTaiLieu, new BsonRegularExpression(keyword, "i")),
                b.Regex(x => x.MaSach, new BsonRegularExpression(keyword, "i"))
            );
        if (!string.IsNullOrWhiteSpace(categoryId))
            filter &= b.Eq(x => x.DanhMucId, categoryId);

        var total = await _books.CountDocumentsAsync(filter);
        var items = await _books.Find(filter).Skip((page - 1) * pageSize).Limit(pageSize).ToListAsync();
        return (items, total);
    }
}
