using LibraryAPI.DTOs.Borrow;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class BorrowController : ControllerBase
{
    private readonly IBorrowService _service;
    public BorrowController(IBorrowService service) => _service = service;

    [HttpGet("due-today")]
    public async Task<IActionResult> DueToday()
        => Ok(await _service.GetDueTodayCountAsync());

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int status = 0)
        => Ok(await _service.GetCountByStatusAsync(status));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int status = 0)
        => Ok(await _service.GetByStatusAsync(status));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId()
        => Ok(await _service.GenerateCardIdAsync());

    [HttpGet("{cardId}")]
    public async Task<IActionResult> GetById(string cardId)
    {
        var result = await _service.GetByIdAsync(cardId);
        return result == null ? NotFound() : Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Borrow([FromBody] BorrowCardCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CreateBorrowAsync(dto, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }

    [HttpPut("return/{cardId}")]
    public async Task<IActionResult> Return(string cardId)
        => await _service.ReturnBookAsync(cardId) ? Ok(new { message = "Trả sách thành công" }) : NotFound();
}
