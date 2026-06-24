namespace LibraryAPI.DTOs.Category;

public class CategoryCreateDto
{
    public string MaDanhMuc { get; set; } = null!;
    public string TenDanhMuc { get; set; } = null!;
    public string? MoTa { get; set; }
    public string? ViTriKhuVuc { get; set; }
}

public class CategoryResponseDto
{
    public string Id { get; set; } = null!;
    public string MaDanhMuc { get; set; } = null!;
    public string TenDanhMuc { get; set; } = null!;
    public string? MoTa { get; set; }
    public string? ViTriKhuVuc { get; set; }
    public DateTime CreatedAt { get; set; }
}
