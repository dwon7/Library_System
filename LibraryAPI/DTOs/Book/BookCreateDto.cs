namespace LibraryAPI.DTOs.Book;

public class BookCreateDto
{
    public string Title { get; set; } = null!;
    public string? CategoryId { get; set; }
    public int PublicationYear { get; set; }
    public string? Publisher { get; set; }
    public List<AuthorCreateDto> Authors { get; set; } = new();
    public string? DocumentType { get; set; }
    public PhysicalInfoCreateDto? PhysicalInfo { get; set; }  // nested from Flutter toJson
    public int TotalQuantity { get; set; }                     // fallback flat field

    public int GetTotalQuantity() =>
        PhysicalInfo?.TotalQuantity > 0 ? PhysicalInfo.TotalQuantity : TotalQuantity;
}

public class PhysicalInfoCreateDto
{
    public int TotalQuantity { get; set; }
    public string? WarehouseLocation { get; set; }
    public string? ShelfId { get; set; }
}

public class AuthorCreateDto
{
    public string FullName { get; set; } = null!;
    public string? Degree { get; set; }
}
