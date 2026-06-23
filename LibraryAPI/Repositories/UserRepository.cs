using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;
namespace LibraryAPI.Repositories;
public class UserRepository : Repository<User>, IUserRepository
{
    private readonly IMongoCollection<User> _users;
    public UserRepository(MongoDbContext ctx) : base(ctx.Users) => _users = ctx.Users;
    public async Task<User?> GetByEmailAsync(string email) =>
        await _users.Find(x => x.Email == email && !x.IsDeleted).FirstOrDefaultAsync();
}
