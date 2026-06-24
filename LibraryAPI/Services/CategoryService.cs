using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Category;
using LibraryAPI.Repositories;

namespace LibraryAPI.Services;

public class CategoryService : ICategoryService
{
    private readonly ICategoryRepository _categoryRepo;
    private readonly IBookRepository _bookRepo;

    public CategoryService(
        ICategoryRepository categoryRepo,
        IBookRepository bookRepo)
    {
        _categoryRepo = categoryRepo;
        _bookRepo = bookRepo;
    }

    public async Task<List<CategoryResponseDto>> GetAllAsync()
    {
        var categories = await _categoryRepo.GetAllActiveAsync();
        return categories.Select(MapToDto).ToList();
    }

    public async Task<CategoryResponseDto?> GetByIdAsync(string id)
    {
        var category = await _categoryRepo.GetByIdAsync(id);
        return category == null ? null : MapToDto(category);
    }

    public async Task<CategoryResponseDto> CreateAsync(
        CategoryCreateDto dto, string userId)
    {
        var category = new Category
        {
            MaDanhMuc = dto.MaDanhMuc,
            TenDanhMuc = dto.TenDanhMuc,
            MoTa = dto.MoTa,
            ViTriKhuVuc = dto.ViTriKhuVuc,
            CreatedBy = userId
        };
        await _categoryRepo.CreateAsync(category);
        return MapToDto(category);
    }

    public async Task<bool> UpdateAsync(
        string id, CategoryCreateDto dto, string userId)
    {
        var category = await _categoryRepo.GetByIdAsync(id);
        if (category == null) return false;

        category.MaDanhMuc = dto.MaDanhMuc;
        category.TenDanhMuc = dto.TenDanhMuc;
        category.MoTa = dto.MoTa;
        category.ViTriKhuVuc = dto.ViTriKhuVuc;
        category.UpdatedBy = userId;

        return await _categoryRepo.UpdateAsync(id, category);
    }

    public async Task<(bool ok, string message)> DeleteAsync(
        string id, string userId)
    {
        // Kiểm tra còn sách liên kết không
        var (books, _) = await _bookRepo.SearchAsync(null, null, null, 1, 1);
        // TODO: Thêm filter theo danh_muc_id khi mở rộng BookRepository

        await _categoryRepo.SoftDeleteAsync(id);
        return (true, "Xóa danh mục thành công");
    }

    public async Task<List<Book>> GetBooksByCategoryAsync(string categoryId)
    {
        // Lấy sách theo danh_muc_id (LINK từ books sang categories)
        var (books, _) = await _bookRepo.SearchAsync(null, null, null, 1, 100);
        return books.Where(b => b.DanhMucId == categoryId).ToList();
    }

    private static CategoryResponseDto MapToDto(Category c) => new()
    {
        Id = c.Id!,
        MaDanhMuc = c.MaDanhMuc,
        TenDanhMuc = c.TenDanhMuc,
        MoTa = c.MoTa,
        ViTriKhuVuc = c.ViTriKhuVuc,
        CreatedAt = c.CreatedAt
    };
}
