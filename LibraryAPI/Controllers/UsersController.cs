using LibraryAPI.DTOs.User;
using LibraryAPI.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly MongoDbContext _ctx;
    public UsersController(MongoDbContext ctx) => _ctx = ctx;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var users = await _ctx.Users.Find(u => !u.IsDeleted).ToListAsync();
        var result = users.Select(u => new UserResponseDto
        {
            UserId = u.Id!,
            FullName = u.HoTen,
            Email = u.Email,
            Major = u.ChuyenNganh,
            PhoneNumber = u.Sdt,
            TotalBorrowCount = 0
        }).ToList();
        return Ok(result);
    }
}
