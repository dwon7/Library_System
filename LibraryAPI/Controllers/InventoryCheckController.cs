using System.Security.Claims;
using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.InventoryCheck;
using LibraryAPI.Infrastructure;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class InventoryChecksController : ControllerBase
{
    private readonly IInventoryCheckService _service;
    private readonly MongoDbContext _ctx;
    public InventoryChecksController(IInventoryCheckService service, MongoDbContext ctx)
    {
        _service = service;
        _ctx = ctx;
    }

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int status = 0)
        => Ok(await _service.GetCountByStatusAsync(status));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int status = 0)
        => Ok(await _service.GetListByStatusAsync(status));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId()
        => Ok(await _service.GenerateAuditIdAsync());

    /// <summary>GET /api/inventorychecks/monthly-trend?status=&year= → [{month, count}] (status: 0=tất cả, 1=đã hoàn thành, 2=chưa hoàn thành)</summary>
    [HttpGet("monthly-trend")]
    public async Task<IActionResult> MonthlyTrend([FromQuery] int status = 0, [FromQuery] int year = 0)
    {
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = new DateTime(year + 1, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var filter = Builders<InventoryCheck>.Filter.And(
            Builders<InventoryCheck>.Filter.Gte(i => i.NgayKiemKe, start),
            Builders<InventoryCheck>.Filter.Lt(i => i.NgayKiemKe, end),
            Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false));
        if (status != 0) filter &= Builders<InventoryCheck>.Filter.Eq(i => i.TrangThai, status);
        var list = await _ctx.InventoryChecks.Find(filter).ToListAsync();
        var monthMap = list.GroupBy(i => i.NgayKiemKe.Month).ToDictionary(g => g.Key, g => g.Count());
        var result = Enumerable.Range(1, 12)
            .Select(m => new { month = m, count = monthMap.TryGetValue(m, out var cnt) ? cnt : 0 });
        return Ok(result);
    }

    /// <summary>GET /api/inventorychecks/condition-ratio?status=&month=&year= → [{categoryName, count, percentage}] (tình trạng sách)</summary>
    [HttpGet("condition-ratio")]
    public async Task<IActionResult> ConditionRatio([FromQuery] int status = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<InventoryCheck>.Filter.And(
            Builders<InventoryCheck>.Filter.Gte(i => i.NgayKiemKe, start),
            Builders<InventoryCheck>.Filter.Lt(i => i.NgayKiemKe, end),
            Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false));
        if (status != 0) filter &= Builders<InventoryCheck>.Filter.Eq(i => i.TrangThai, status);
        var list = await _ctx.InventoryChecks.Find(filter).ToListAsync();

        var labels = new Dictionary<int, string>
        {
            [BookCondition.Good] = "Còn sử dụng",
            [BookCondition.Damaged] = "Rách nát",
            [BookCondition.Lost] = "Mất",
            [BookCondition.NotInventoried] = "Chưa kiểm kê"
        };
        var conditionCount = new Dictionary<int, int>();
        foreach (var i in list)
            foreach (var detail in i.KetQuaChiTiet)
            {
                conditionCount.TryGetValue(detail.TinhTrangSach, out var cnt);
                conditionCount[detail.TinhTrangSach] = cnt + detail.SoLuong;
            }
        var total = conditionCount.Values.Sum();
        var result = conditionCount.Select(kv => new
        {
            categoryName = labels.TryGetValue(kv.Key, out var l) ? l : "Khác",
            count = kv.Value,
            percentage = total > 0 ? Math.Round((double)kv.Value / total * 100, 1) : 0.0
        }).ToList();
        return Ok(result);
    }

    /// <summary>GET /api/inventorychecks/top-chiefs?status=&month=&year= → [{userName, count}] (tối đa 5, "Trưởng ban" phụ trách nhiều đợt kiểm kê nhất)</summary>
    [HttpGet("top-chiefs")]
    public async Task<IActionResult> TopChiefs([FromQuery] int status = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<InventoryCheck>.Filter.And(
            Builders<InventoryCheck>.Filter.Gte(i => i.NgayKiemKe, start),
            Builders<InventoryCheck>.Filter.Lt(i => i.NgayKiemKe, end),
            Builders<InventoryCheck>.Filter.Eq(i => i.IsDeleted, false));
        if (status != 0) filter &= Builders<InventoryCheck>.Filter.Eq(i => i.TrangThai, status);
        var list = await _ctx.InventoryChecks.Find(filter).ToListAsync();

        var chiefCount = new Dictionary<string, int>();
        foreach (var i in list)
        {
            var chief = i.HoiDongKiemKe.FirstOrDefault(m => m.VaiTro == "Trưởng ban");
            if (chief == null || string.IsNullOrEmpty(chief.HoTen)) continue;
            chiefCount.TryGetValue(chief.HoTen, out var c);
            chiefCount[chief.HoTen] = c + 1;
        }
        var result = chiefCount
            .OrderByDescending(kv => kv.Value)
            .Take(5)
            .Select(kv => new { userName = kv.Key, count = kv.Value })
            .ToList();
        return Ok(result);
    }

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
