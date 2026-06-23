using LibraryAPI.Domain.Entities;
namespace LibraryAPI.Repositories;
public interface IBookRepository : IRepository<Book>
{
    Task<(List<Book> items, long total)> SearchAsync(string? keyword, string? theLoai, int? nam, int page, int pageSize);
}
