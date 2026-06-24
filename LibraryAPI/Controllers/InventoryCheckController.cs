using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LibraryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = Roles.Admin + "," + Roles.Librarian)]
public class InventoryChecksController : ControllerBase
{
    private readonly IInventoryCheckService _service;

    public InventoryChecksController(IInventoryCheckService service) =>
        _service = service;

    /// <summary>GET /api/inventorychecks — Lấy tất cả phiếu kiểm kê</summary>
    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _service.GetAllAsync());

    /// <summary>GET /api/inventorychecks/{id}</summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var result = await _service.GetByIdAsync(id);
        return result == null ? NotFound() : Ok(result);
    }

    /// <summary>GET /api/inventorychecks/{id}/statistics — Thống kê kiểm kê</summary>
    [HttpGet("{id}/statistics")]
    public async Task<IActionResult> GetStatistics(string id) =>
        Ok(await _service.GetStatisticsAsync(id));

    /// <summary>GET /api/inventorychecks/filter?trangThai=1</summary>
    [HttpGet("filter")]
    public async Task<IActionResult> Filter([FromQuery] int trangThai) =>
        Ok(await _service.GetByTrangThaiAsync(trangThai));

    /// <summary>POST /api/inventorychecks — Tạo phiếu kiểm kê mới</summary>
    [HttpPost]
    public async Task<IActionResult> Create(InventoryCheckCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        return Ok(await _service.CreateAsync(dto, userId));
    }

    /// <summary>
    /// PUT /api/inventorychecks/{id}/complete — Hoàn thành kiểm kê
    /// Dùng MongoDB Transaction: cập nhật trạng thái + SoLuongCon trong books
    /// </summary>
    [HttpPut("{id}/complete")]
    public async Task<IActionResult> Complete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CompleteInventoryAsync(id, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }
}
