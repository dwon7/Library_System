using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Category;

namespace LibraryAPI.Services;

public interface ICategoryService
{
    /// <summary>Lấy tất cả danh mục đang hoạt động</summary>
    Task<List<CategoryResponseDto>> GetAllAsync();

    /// <summary>Lấy danh mục theo ID</summary>
    Task<CategoryResponseDto?> GetByIdAsync(string id);

    /// <summary>Tạo danh mục mới</summary>
    Task<CategoryResponseDto> CreateAsync(CategoryCreateDto dto, string userId);

    /// <summary>Cập nhật danh mục</summary>
    Task<bool> UpdateAsync(string id, CategoryCreateDto dto, string userId);

    /// <summary>Xóa mềm danh mục (kiểm tra không còn sách liên kết)</summary>
    Task<(bool ok, string message)> DeleteAsync(string id, string userId);

    /// <summary>Lấy danh sách sách thuộc danh mục</summary>
    Task<List<Book>> GetBooksByCategoryAsync(string categoryId);
}
