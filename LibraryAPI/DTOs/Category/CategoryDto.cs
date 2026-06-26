namespace LibraryAPI.DTOs.Category;

public class CategoryCreateDto
{
    public string CategoryName { get; set; } = null!;
    public string? Description { get; set; }
    public string? StorageLocation { get; set; }
}

public class CategoryResponseDto
{
    public string CategoryId { get; set; } = null!;      // _id (ObjectId) — used by books as filter key
    public string CategoryName { get; set; } = null!;    // ten_danh_muc
    public string? Description { get; set; }             // mo_ta
    public string? StorageLocation { get; set; }         // vi_tri_khu_vuc
}
