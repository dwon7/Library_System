using System.Security.Claims;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Mvc;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class InventoryChecksController : ControllerBase
{
    private readonly IInventoryCheckService _service;
    public InventoryChecksController(IInventoryCheckService service) => _service = service;

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int status = 0)
        => Ok(await _service.GetCountByStatusAsync(status));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int status = 0)
        => Ok(await _service.GetListByStatusAsync(status));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId()
        => Ok(await _service.GenerateAuditIdAsync());

    [HttpGet("{auditId}")]
    public async Task<IActionResult> GetById(string auditId)
    {
        var result = await _service.GetByIdAsync(auditId);
        return result == null ? NotFound() : Ok(result);
    }

    [HttpGet("{id}/statistics")]
    public async Task<IActionResult> GetStatistics(string id)
        => Ok(await _service.GetStatisticsAsync(id));


    [HttpPost]
    public async Task<IActionResult> Create([FromBody] InventoryCheckCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var result = await _service.CreateAsync(dto, userId);
        return Ok(result.AuditId);  // Flutter dùng ApiClient.asString() → cần trả về string
    }

    [HttpPut("{id}/complete")]
    public async Task<IActionResult> Complete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CompleteInventoryAsync(id, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }

    [HttpGet("{auditId}/progress")]
    public async Task<IActionResult> GetProgress(string auditId)
        => Ok(await _service.GetAuditProgressAsync(auditId));

    [HttpPost("{auditId}/scan")]
    public async Task<IActionResult> Scan(string auditId, [FromBody] ScanQRDto dto)
        => Ok(await _service.ScanQRAsync(auditId, dto.QrValue));

    [HttpPut("{auditId}/books/{bookId}/condition")]
    public async Task<IActionResult> UpdateCondition(string auditId, string bookId, [FromBody] UpdateBookConditionDto dto)
        => Ok(await _service.UpdateBookConditionAsync(auditId, bookId, dto.ConditionType));

    [HttpGet("{auditId}/books")]
    public async Task<IActionResult> GetBooks(string auditId, [FromQuery] int status = 1)
        => Ok(await _service.GetBooksByStatusAsync(auditId, status));

    [HttpDelete("{auditId}")]
    public async Task<IActionResult> Delete(string auditId)
    {
        var result = await _service.DeleteAuditAsync(auditId);
        return result ? Ok(true) : NotFound(false);
    }
}
