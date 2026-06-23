using LibraryAPI.DTOs.Book;
using LibraryAPI.DTOs.Common;
namespace LibraryAPI.Services;
public interface IBookService
{
    Task<PagedResult<BookResponseDto>> SearchAsync(string? keyword, string? theLoai, int? nam, int page, int pageSize);
    Task<BookResponseDto?> GetByIdAsync(string id);
    Task<BookResponseDto> CreateAsync(BookCreateDto dto, string userId);
    Task<bool> UpdateAsync(string id, BookUpdateDto dto, string userId);
    Task<bool> DeleteAsync(string id, string userId);
}
