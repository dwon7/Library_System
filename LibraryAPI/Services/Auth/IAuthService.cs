using LibraryAPI.DTOs.Auth;
namespace LibraryAPI.Services.Auth;
public interface IAuthService
{
    Task<TokenResponseDto> RegisterAsync(RegisterDto dto);
    Task<TokenResponseDto> LoginAsync(LoginDto dto);
    Task<TokenResponseDto> RefreshAsync(string refreshToken);
    Task LogoutAsync(string userId);
}
