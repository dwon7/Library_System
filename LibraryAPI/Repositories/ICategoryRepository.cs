using LibraryAPI.Domain.Entities;

namespace LibraryAPI.Repositories;

public interface ICategoryRepository : IRepository<Category>
{
    Task<Category?> GetByMaDanhMucAsync(string maDanhMuc);
    Task<List<Category>> GetAllActiveAsync();
}
