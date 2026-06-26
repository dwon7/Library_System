using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.Category;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LibraryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CategoriesController : ControllerBase
{
    private readonly ICategoryService _service;

    public CategoriesController(ICategoryService service) => _service = service;

    /// <summary>GET /api/categories — Lấy tất cả danh mục (public)</summary>
    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _service.GetAllAsync());

    /// <summary>GET /api/categories/{id} — Lấy danh mục theo ID</summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var result = await _service.GetByIdAsync(id);
        return result == null ? NotFound() : Ok(result);
    }

    /// <summary>GET /api/categories/{id}/books — Sách thuộc danh mục</summary>
    [HttpGet("{id}/books")]
    public async Task<IActionResult> GetBooks(string id) =>
        Ok(await _service.GetBooksByCategoryAsync(id));

    /// <summary>POST /api/categories — Tạo danh mục (Admin/Librarian)</summary>

    [HttpPost]
    public async Task<IActionResult> Create(CategoryCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return Ok(await _service.CreateAsync(dto, userId));
    }

    /// <summary>PUT /api/categories/{id} — Cập nhật danh mục (Admin/Librarian)</summary>

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(string id, CategoryCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return await _service.UpdateAsync(id, dto, userId) ? NoContent() : NotFound();
    }

    /// <summary>DELETE /api/categories/{id} — Xóa danh mục (Admin)</summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.DeleteAsync(id, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }
}
