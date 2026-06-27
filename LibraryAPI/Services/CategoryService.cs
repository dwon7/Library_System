using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Category;
using LibraryAPI.Repositories;
namespace LibraryAPI.Services;
public class CategoryService : ICategoryService
{
    private readonly ICategoryRepository _categoryRepo;
    private readonly IBookRepository _bookRepo;
    public CategoryService(ICategoryRepository categoryRepo, IBookRepository bookRepo)
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

    public async Task<CategoryResponseDto> CreateAsync(CategoryCreateDto dto, string userId)
    {
        var category = new Category
        {
            MaDanhMuc = $"DM-{Guid.NewGuid().ToString("N")[..6].ToUpper()}",
            TenDanhMuc = dto.CategoryName,
            MoTa = dto.Description,
            ViTriKhuVuc = dto.StorageLocation,
            CreatedBy = userId
        };
        await _categoryRepo.CreateAsync(category);
        return MapToDto(category);
    }

    public async Task<bool> UpdateAsync(string id, CategoryCreateDto dto, string userId)
    {
        var category = await _categoryRepo.GetByIdAsync(id);
        if (category == null) return false;
        category.TenDanhMuc = dto.CategoryName;
        category.MoTa = dto.Description;
        category.ViTriKhuVuc = dto.StorageLocation;
        category.UpdatedBy = userId;
        return await _categoryRepo.UpdateAsync(id, category);
    }

    public async Task<(bool ok, string message)> DeleteAsync(string id, string userId)
    {
        await _categoryRepo.SoftDeleteAsync(id);
        return (true, "Xóa danh mục thành công");
    }

    public async Task<List<Book>> GetBooksByCategoryAsync(string categoryId)
    {
        var (books, _) = await _bookRepo.SearchAsync(null, categoryId, 1, 100);
        return books;
    }

    private static CategoryResponseDto MapToDto(Category c) => new()
    {
        CategoryId = c.Id!,           // MongoDB ObjectId — used by books as filter key
        CategoryName = c.TenDanhMuc,
        Description = c.MoTa,
        StorageLocation = c.ViTriKhuVuc
    };
}
