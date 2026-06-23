using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Bson;
using MongoDB.Driver;
namespace LibraryAPI.Repositories;
public class BookRepository : Repository<Book>, IBookRepository
{
    private readonly IMongoCollection<Book> _books;
    public BookRepository(MongoDbContext ctx) : base(ctx.Books) => _books = ctx.Books;

    public async Task<(List<Book> items, long total)> SearchAsync(string? keyword, string? theLoai, int? nam, int page, int pageSize)
    {
        var b = Builders<Book>.Filter;
        var filter = b.Eq(x => x.IsDeleted, false);
        if (!string.IsNullOrWhiteSpace(keyword))
            filter &= b.Regex(x => x.TenTaiLieu, new BsonRegularExpression(keyword, "i"));
        if (!string.IsNullOrWhiteSpace(theLoai))
            filter &= b.AnyEq(x => x.TheLoai, theLoai);
        if (nam.HasValue)
            filter &= b.Eq(x => x.NamXuatBan, nam.Value);

        var total = await _books.CountDocumentsAsync(filter);
        var items = await _books.Find(filter).Skip((page - 1) * pageSize).Limit(pageSize).ToListAsync();
        return (items, total);
    }
}
