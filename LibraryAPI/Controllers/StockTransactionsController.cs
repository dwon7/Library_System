using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.StockTransaction;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class StockTransactionsController : ControllerBase
{
    private readonly IStockTransactionService _service;
    public StockTransactionsController(IStockTransactionService service) => _service = service;

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int type = 0)
        => Ok(await _service.GetCountByTypeAsync(type));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int type = 0)
        => Ok(await _service.GetListByTypeAsync(type));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId([FromQuery] int type = 1)
        => Ok(await _service.GenerateLedgerIdAsync(type));

    [HttpGet("{ledgerId}")]
    public async Task<IActionResult> GetById(string ledgerId)
    {
        var result = await _service.GetByIdAsync(ledgerId);
        return result == null ? NotFound() : Ok(result);
    }


    [HttpPost("import")]
    public async Task<IActionResult> Import([FromBody] StockTransactionCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message, data) = await _service.CreateImportAsync(dto, userId);
        return ok ? Ok(new { message, data }) : BadRequest(new { message });
    }

    [HttpPost("export")]
    public async Task<IActionResult> Export([FromBody] StockTransactionCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message, data) = await _service.CreateExportAsync(dto, userId);
        return ok ? Ok(new { message, data }) : BadRequest(new { message });
    }
}
