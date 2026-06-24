using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.StockTransaction;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LibraryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = Roles.Admin + "," + Roles.Librarian)]
public class StockTransactionsController : ControllerBase
{
    private readonly IStockTransactionService _service;

    public StockTransactionsController(IStockTransactionService service) =>
        _service = service;

    /// <summary>GET /api/stocktransactions — Lấy tất cả phiếu</summary>
    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _service.GetAllAsync());

    /// <summary>GET /api/stocktransactions/{id}</summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var result = await _service.GetByIdAsync(id);
        return result == null ? NotFound() : Ok(result);
    }

    /// <summary>GET /api/stocktransactions/filter?loaiPhieu=1</summary>
    [HttpGet("filter")]
    public async Task<IActionResult> Filter([FromQuery] int loaiPhieu) =>
        Ok(await _service.GetByLoaiPhieuAsync(loaiPhieu));

    /// <summary>GET /api/stocktransactions/daterange?from=...&to=...</summary>
    [HttpGet("daterange")]
    public async Task<IActionResult> GetByDateRange(
        [FromQuery] DateTime from, [FromQuery] DateTime to) =>
        Ok(await _service.GetByDateRangeAsync(from, to));

    /// <summary>
    /// POST /api/stocktransactions/import — Nhập kho
    /// Dùng MongoDB Transaction: tạo phiếu + tăng SoLuongCon trong books
    /// </summary>
    [HttpPost("import")]
    public async Task<IActionResult> Import(StockTransactionCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message, data) = await _service.CreateImportAsync(dto, userId);
        return ok ? Ok(new { message, data }) : BadRequest(new { message });
    }

    /// <summary>
    /// POST /api/stocktransactions/export — Xuất kho
    /// Dùng MongoDB Transaction: kiểm tra số lượng + tạo phiếu + giảm SoLuongCon
    /// </summary>
    [HttpPost("export")]
    public async Task<IActionResult> Export(StockTransactionCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message, data) = await _service.CreateExportAsync(dto, userId);
        return ok ? Ok(new { message, data }) : BadRequest(new { message });
    }
}
