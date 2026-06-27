namespace LibraryAPI.DTOs.Borrow;

public class BorrowCardCreateDto
{
    public string CardId { get; set; } = null!;
    public string UserId { get; set; } = null!;
    public string? UserName { get; set; }
    public DateTime? BorrowDate { get; set; }
    public DateTime? DueDate { get; set; }
    public int Status { get; set; } = 2;
    public List<BorrowDetailCreateDto> BorrowDetails { get; set; } = new();
}

public class BorrowDetailCreateDto
{
    public string BookId { get; set; } = null!;
    public string? BookName { get; set; }
    public decimal? BookPrice { get; set; }
    public int Quantity { get; set; }
}

public class BorrowCardResponseDto
{
    public string CardId { get; set; } = null!;       // ma_phieu (e.g. PM-001)
    public string UserId { get; set; } = null!;       // doc_gia_id (ObjectId)
    public string? UserName { get; set; }             // resolved from users
    public DateTime BorrowDate { get; set; }          // ngay_muon
    public DateTime DueDate { get; set; }             // ngay_hen_tra
    public int Status { get; set; }                   // 1=done, 2=borrowing, 3=overdue
    public List<BorrowDetailResponseDto> BorrowDetails { get; set; } = new();
}

public class BorrowDetailResponseDto
{
    public string BookId { get; set; } = null!;      // sach_id (ObjectId)
    public string? BookName { get; set; }            // resolved from books
    public decimal BookPrice { get; set; }
    public int Quantity { get; set; }                // so_luong
}
