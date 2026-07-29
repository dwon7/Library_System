using System.Security.Claims;
using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using LibraryAPI.DTOs.StockTransaction;
using LibraryAPI.Infrastructure;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class StockTransactionsController : ControllerBase
{
    private readonly IStockTransactionService _service;
    private readonly MongoDbContext _ctx;
    public StockTransactionsController(IStockTransactionService service, MongoDbContext ctx)
    {
        _service = service;
        _ctx = ctx;
    }

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int type = 0)
        => Ok(await _service.GetCountByTypeAsync(type));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int type = 0)
        => Ok(await _service.GetListByTypeAsync(type));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId([FromQuery] int type = 1)
        => Ok(await _service.GenerateLedgerIdAsync(type));

    /// <summary>GET /api/stocktransactions/monthly-trend?type=&year= → [{month, count}] (type: 0=tất cả, 1=nhập, 2=xuất)</summary>
    [HttpGet("monthly-trend")]
    public async Task<IActionResult> MonthlyTrend([FromQuery] int type = 0, [FromQuery] int year = 0)
    {
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = new DateTime(year + 1, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var filter = Builders<StockTransaction>.Filter.And(
            Builders<StockTransaction>.Filter.Gte(t => t.NgayThucHien, start),
            Builders<StockTransaction>.Filter.Lt(t => t.NgayThucHien, end),
            Builders<StockTransaction>.Filter.Eq(t => t.IsDeleted, false));
        if (type != 0) filter &= Builders<StockTransaction>.Filter.Eq(t => t.LoaiPhieu, type);
        var list = await _ctx.StockTransactions.Find(filter).ToListAsync();
        var monthMap = list.GroupBy(t => t.NgayThucHien.Month).ToDictionary(g => g.Key, g => g.Count());
        var result = Enumerable.Range(1, 12)
            .Select(m => new { month = m, count = monthMap.TryGetValue(m, out var cnt) ? cnt : 0 });
        return Ok(result);
    }

    /// <summary>GET /api/stocktransactions/partner-ratio?type=&month=&year= → [{categoryName, count, percentage}] (count = tổng giá trị giao dịch)</summary>
    [HttpGet("partner-ratio")]
    public async Task<IActionResult> PartnerRatio([FromQuery] int type = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<StockTransaction>.Filter.And(
            Builders<StockTransaction>.Filter.Gte(t => t.NgayThucHien, start),
            Builders<StockTransaction>.Filter.Lt(t => t.NgayThucHien, end),
            Builders<StockTransaction>.Filter.Eq(t => t.IsDeleted, false));
        if (type != 0) filter &= Builders<StockTransaction>.Filter.Eq(t => t.LoaiPhieu, type);
        var list = await _ctx.StockTransactions.Find(filter).ToListAsync();

        var partnerValue = new Dictionary<string, decimal>();
        foreach (var t in list)
        {
            var name = t.DoiTac?.TenDoiTac;
            if (string.IsNullOrEmpty(name)) continue;
            partnerValue.TryGetValue(name, out var v);
            partnerValue[name] = v + t.TongTien;
        }
        var total = partnerValue.Values.Sum();
        var result = partnerValue.Select(kv => new
        {
            categoryName = kv.Key,
            count = (long)kv.Value,
            percentage = total > 0 ? Math.Round((double)(kv.Value / total * 100), 1) : 0.0
        }).OrderByDescending(x => x.count).ToList();
        return Ok(result);
    }

    /// <summary>GET /api/stocktransactions/top-partners?type=&month=&year= → [{userName, count}] (tối đa 5, count = số giao dịch)</summary>
    [HttpGet("top-partners")]
    public async Task<IActionResult> TopPartners([FromQuery] int type = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<StockTransaction>.Filter.And(
            Builders<StockTransaction>.Filter.Gte(t => t.NgayThucHien, start),
            Builders<StockTransaction>.Filter.Lt(t => t.NgayThucHien, end),
            Builders<StockTransaction>.Filter.Eq(t => t.IsDeleted, false));
        if (type != 0) filter &= Builders<StockTransaction>.Filter.Eq(t => t.LoaiPhieu, type);
        var list = await _ctx.StockTransactions.Find(filter).ToListAsync();

        var partnerCount = new Dictionary<string, int>();
        foreach (var t in list)
        {
            var name = t.DoiTac?.TenDoiTac;
            if (string.IsNullOrEmpty(name)) continue;
            partnerCount.TryGetValue(name, out var c);
            partnerCount[name] = c + 1;
        }
        var result = partnerCount
            .OrderByDescending(kv => kv.Value)
            .Take(5)
            .Select(kv => new { userName = kv.Key, count = kv.Value })
            .ToList();
        return Ok(result);
    }

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

    [HttpDelete("{ledgerId}")]
    public async Task<IActionResult> Delete(string ledgerId)
    {
        var result = await _service.DeleteAsync(ledgerId);
        return result ? Ok(true) : NotFound(false);
    }
}
