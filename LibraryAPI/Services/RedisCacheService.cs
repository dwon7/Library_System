using StackExchange.Redis;
namespace LibraryAPI.Services;
public class RedisCacheService
{
    private readonly IDatabase _db;
    public RedisCacheService(IConnectionMultiplexer redis) => _db = redis.GetDatabase();
    public async Task SetAsync(string key, string value, TimeSpan ttl) => await _db.StringSetAsync(key, value, ttl);
    public async Task<string?> GetAsync(string key) => await _db.StringGetAsync(key);
    public async Task RemoveAsync(string key) => await _db.KeyDeleteAsync(key);
}
