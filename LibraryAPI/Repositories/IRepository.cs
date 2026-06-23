using System.Linq.Expressions;

namespace LibraryAPI.Repositories;

public interface IRepository<T> where T : class
{
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(string id);
    Task<T?> FindOneAsync(Expression<Func<T, bool>> filter);
    Task CreateAsync(T entity);
    Task<bool> UpdateAsync(string id, T entity);
    Task<bool> SoftDeleteAsync(string id);
}
