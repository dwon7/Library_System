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
    public async Task<IActionResult> Search(string? keyword, string? theLoai, int? nam, int page = 1, int pageSize = 20)
        => Ok(await _service.SearchAsync(keyword, theLoai, nam, page, pageSize));

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var book = await _service.GetByIdAsync(id);
        return book == null ? NotFound() : Ok(book);
    }

    [Authorize(Roles = Roles.Admin + "," + Roles.Librarian)]
    [HttpPost]
    public async Task<IActionResult> Create(BookCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return Ok(await _service.CreateAsync(dto, userId));
    }

    [Authorize(Roles = Roles.Admin + "," + Roles.Librarian)]
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(string id, BookUpdateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return await _service.UpdateAsync(id, dto, userId) ? NoContent() : NotFound();
    }

    [Authorize(Roles = Roles.Admin)]
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return await _service.DeleteAsync(id, userId) ? NoContent() : NotFound();
    }
}
