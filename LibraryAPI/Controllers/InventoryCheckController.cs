using System.Security.Claims;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
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
        return Ok(await _service.CreateAsync(dto, userId));
    }

    [HttpPut("{id}/complete")]
    public async Task<IActionResult> Complete(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CompleteInventoryAsync(id, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }
}
