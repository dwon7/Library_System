using LibraryAPI.Domain.Entities;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BorrowController : ControllerBase
{
    private readonly IBorrowService _service;
    public BorrowController(IBorrowService service) => _service = service;

    [HttpPost]
    public async Task<IActionResult> Borrow(BorrowCard card)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CreateBorrowAsync(card, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }

    [HttpPut("return/{cardId}")]
    public async Task<IActionResult> Return(string cardId)
        => await _service.ReturnBookAsync(cardId) ? Ok(new { message = "Trả sách thành công" }) : NotFound();
}
