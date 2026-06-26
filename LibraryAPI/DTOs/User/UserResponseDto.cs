namespace LibraryAPI.DTOs.User;

public class UserResponseDto
{
    public string UserId { get; set; } = null!;      // _id (ObjectId)
    public string FullName { get; set; } = null!;    // ho_ten
    public string Email { get; set; } = null!;       // email
    public string? Major { get; set; }               // chuyen_nganh
    public string? PhoneNumber { get; set; }         // sdt
    public int TotalBorrowCount { get; set; }        // queried from borrow_cards
}
