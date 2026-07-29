using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Auth;
using LibraryAPI.Repositories;
using BCrypt.Net;

namespace LibraryAPI.Services.Auth;
public class AuthService : IAuthService
{
    private readonly IUserRepository _users;
    private readonly TokenService _tokenService;
    private readonly RedisCacheService _cache;
    private readonly IConfiguration _config;

    public AuthService(IUserRepository users, TokenService tokenService, RedisCacheService cache, IConfiguration config)
    {
        _users = users; _tokenService = tokenService; _cache = cache; _config = config;
    }

    public async Task<TokenResponseDto> RegisterAsync(RegisterDto dto)
    {
        var existing = await _users.GetByEmailAsync(dto.Email);
        if (existing != null) throw new Exception("Email đã tồn tại");
        var user = new User
        {
            HoTen = dto.HoTen,
            Email = dto.Email,
            Sdt = dto.Sdt,
            Role = "Member",
            MaDocGia = "DG" + DateTime.UtcNow.Ticks,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password)
        };
        await _users.CreateAsync(user);
        return await IssueTokensAsync(user);
    }

    public async Task<TokenResponseDto> LoginAsync(LoginDto dto)
    {
        var user = await _users.GetByEmailAsync(dto.Email);
        if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))
            throw new UnauthorizedAccessException("Sai email hoặc mật khẩu");
        return await IssueTokensAsync(user);
    }

    private async Task<TokenResponseDto> IssueTokensAsync(User user)
    {
        var access = _tokenService.GenerateAccessToken(user);
        var refresh = _tokenService.GenerateRefreshToken();
        var days = int.Parse(_config["Jwt:RefreshTokenDays"]!);
        await _cache.SetAsync($"refresh:{user.Id}", refresh, TimeSpan.FromDays(days));
        return new TokenResponseDto { AccessToken = access, RefreshToken = refresh };
    }

    public async Task<TokenResponseDto> RefreshAsync(string refreshToken)
    {
        throw new NotImplementedException("Demo: so khớp refresh token lưu trong Redis theo userId rồi cấp token mới");
    }

    public async Task LogoutAsync(string userId) => await _cache.RemoveAsync($"refresh:{userId}");
}
