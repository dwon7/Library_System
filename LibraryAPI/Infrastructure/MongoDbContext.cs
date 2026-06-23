using LibraryAPI.Domain.Entities;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace LibraryAPI.Infrastructure;

public class MongoDbContext
{
    public IMongoDatabase Database { get; }
    public IMongoClient Client { get; }

    public MongoDbContext(IOptions<MongoDbSettings> settings)
    {
        Client = new MongoClient(settings.Value.ConnectionString);
        Database = Client.GetDatabase(settings.Value.DatabaseName);
    }

    public IMongoCollection<Book> Books => Database.GetCollection<Book>("books");
    public IMongoCollection<User> Users => Database.GetCollection<User>("users");
    public IMongoCollection<BorrowCard> BorrowCards => Database.GetCollection<BorrowCard>("borrow_cards");
    public IMongoCollection<RefreshToken> RefreshTokens => Database.GetCollection<RefreshToken>("refresh_tokens");
    public IMongoCollection<AuditLog> AuditLogs => Database.GetCollection<AuditLog>("audit_logs");
}
