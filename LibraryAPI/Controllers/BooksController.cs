using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.Book;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    private readonly IBookService _service;
    public BooksController(IBookService service) => _service = service;

    [HttpGet("search")]
    public async Task<IActionResult> Search(
        [FromQuery] string? keyword,
        [FromQuery] string? categoryId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
        => Ok(await _service.SearchAsync(keyword, categoryId, page, pageSize));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId()
        => Ok(await _service.GenerateBookIdAsync());

    [HttpGet("by-ids")]
    public async Task<IActionResult> GetByIds([FromQuery] string ids)
    {
        var idList = (ids ?? string.Empty)
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .ToList();
        return Ok(await _service.GetByIdsAsync(idList));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var book = await _service.GetByIdAsync(id);
        return book == null ? NotFound() : Ok(book);
    }

    
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] BookCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return Ok(await _service.CreateAsync(dto, userId));
    }


    [HttpPut("{id}")]
    public async Task<IActionResult> Update(string id, [FromBody] BookUpdateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return await _service.UpdateAsync(id, dto, userId) ? NoContent() : NotFound();
    }


    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return await _service.DeleteAsync(id, userId) ? NoContent() : NotFound();
    }
}
