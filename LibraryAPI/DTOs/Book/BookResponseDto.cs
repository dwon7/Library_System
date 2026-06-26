namespace LibraryAPI.DTOs.Book;

public class BookResponseDto
{
    public string BookId { get; set; } = null!;          
    public string Title { get; set; } = null!;    
    public string? CategoryId { get; set; }     
    public int PublicationYear { get; set; }           
    public string? Publisher { get; set; }           
    public List<AuthorResponseDto> Authors { get; set; } = new();  
    public string DocumentType { get; set; } = null!;
    public string? BookCode { get; set; }
    public PhysicalInfoDto PhysicalInfo { get; set; } = new();
    public string Status { get; set; } = "available";  
}

public class AuthorResponseDto
{
    public string FullName { get; set; } = null!;  
    public string? Degree { get; set; }      
}

public class PhysicalInfoDto
{
    public int TotalQuantity { get; set; }        
    public int AvailableQuantity { get; set; } 
}
