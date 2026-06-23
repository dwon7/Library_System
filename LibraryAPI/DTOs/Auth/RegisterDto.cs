namespace LibraryAPI.DTOs.Auth;
public class RegisterDto
{
    public string HoTen { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
    public string? Sdt { get; set; }
}
