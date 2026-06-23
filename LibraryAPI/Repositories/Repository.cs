using System.Linq.Expressions;
using LibraryAPI.Domain.Entities;
using MongoDB.Driver;

namespace LibraryAPI.Repositories;

public class Repository<T> : IRepository<T> where T : BaseEntity
{
    protected readonly IMongoCollection<T> _collection;

    public Repository(IMongoCollection<T> collection) => _collection = collection;

    public async Task<List<T>> GetAllAsync() =>
        await _collection.Find(x => !x.IsDeleted).ToListAsync();

    public async Task<T?> GetByIdAsync(string id) =>
        await _collection.Find(x => x.Id == id && !x.IsDeleted).FirstOrDefaultAsync();

    public async Task<T?> FindOneAsync(Expression<Func<T, bool>> filter) =>
        await _collection.Find(filter).FirstOrDefaultAsync();

    public async Task CreateAsync(T entity) => await _collection.InsertOneAsync(entity);

    public async Task<bool> UpdateAsync(string id, T entity)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        var result = await _collection.ReplaceOneAsync(x => x.Id == id, entity);
        return result.ModifiedCount > 0;
    }

    public async Task<bool> SoftDeleteAsync(string id)
    {
        var update = Builders<T>.Update
            .Set(x => x.IsDeleted, true)
            .Set(x => x.DeletedAt, DateTime.UtcNow);
        var result = await _collection.UpdateOneAsync(x => x.Id == id, update);
        return result.ModifiedCount > 0;
    }
}
