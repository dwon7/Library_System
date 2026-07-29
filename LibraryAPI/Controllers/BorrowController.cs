using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Borrow;
using LibraryAPI.Infrastructure;
using LibraryAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using System.Security.Claims;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class BorrowController : ControllerBase
{
    private readonly IBorrowService _service;
    private readonly MongoDbContext _ctx;
    public BorrowController(IBorrowService service, MongoDbContext ctx)
    {
        _service = service;
        _ctx = ctx;
    }

    [HttpGet("due-today")]
    public async Task<IActionResult> DueToday()
        => Ok(await _service.GetDueTodayCountAsync());

    [HttpGet("count")]
    public async Task<IActionResult> Count([FromQuery] int status = 0)
        => Ok(await _service.GetCountByStatusAsync(status));

    [HttpGet("list")]
    public async Task<IActionResult> List([FromQuery] int status = 0)
        => Ok(await _service.GetByStatusAsync(status));

    [HttpGet("generate-id")]
    public async Task<IActionResult> GenerateId()
        => Ok(await _service.GenerateCardIdAsync());

    /// <summary>GET /api/borrow/monthly-trend?status=&year= → [{month, count}] (status: 0=tất cả)</summary>
    [HttpGet("monthly-trend")]
    public async Task<IActionResult> MonthlyTrend([FromQuery] int status = 0, [FromQuery] int year = 0)
    {
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = new DateTime(year + 1, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var filter = Builders<BorrowCard>.Filter.And(
            Builders<BorrowCard>.Filter.Gte(c => c.NgayMuon, start),
            Builders<BorrowCard>.Filter.Lt(c => c.NgayMuon, end),
            Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false));
        if (status != 0) filter &= Builders<BorrowCard>.Filter.Eq(c => c.TrangThai, status);
        var cards = await _ctx.BorrowCards.Find(filter).ToListAsync();
        var monthMap = cards.GroupBy(c => c.NgayMuon.Month).ToDictionary(g => g.Key, g => g.Count());
        var result = Enumerable.Range(1, 12)
            .Select(m => new { month = m, count = monthMap.TryGetValue(m, out var cnt) ? cnt : 0 });
        return Ok(result);
    }

    /// <summary>GET /api/borrow/category-ratio?status=&month=&year= → [{categoryName, count, percentage}]</summary>
    [HttpGet("category-ratio")]
    public async Task<IActionResult> CategoryRatio([FromQuery] int status = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<BorrowCard>.Filter.And(
            Builders<BorrowCard>.Filter.Gte(c => c.NgayMuon, start),
            Builders<BorrowCard>.Filter.Lt(c => c.NgayMuon, end),
            Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false));
        if (status != 0) filter &= Builders<BorrowCard>.Filter.Eq(c => c.TrangThai, status);
        var cards = await _ctx.BorrowCards.Find(filter).ToListAsync();
        var bookIds = cards.SelectMany(c => c.ChiTietMuon.Select(d => d.SachId)).Distinct().ToList();
        if (bookIds.Count == 0) return Ok(new List<object>());

        var books = await _ctx.Books.Find(b => bookIds.Contains(b.Id!) && !b.IsDeleted).ToListAsync();
        var categoryIds = books.Where(b => b.DanhMucId != null).Select(b => b.DanhMucId!).Distinct().ToList();
        var categories = await _ctx.Categories.Find(c => categoryIds.Contains(c.Id!) && !c.IsDeleted).ToListAsync();
        var categoryMap = categories.ToDictionary(c => c.Id!, c => c.TenDanhMuc);
        var bookCategoryMap = books.ToDictionary(b => b.Id!, b => b.DanhMucId ?? "unknown");

        var countByCategory = new Dictionary<string, int>();
        foreach (var card in cards)
            foreach (var detail in card.ChiTietMuon)
                if (bookCategoryMap.TryGetValue(detail.SachId, out var catId))
                {
                    countByCategory.TryGetValue(catId, out var cnt);
                    countByCategory[catId] = cnt + detail.SoLuong;
                }
        var total = countByCategory.Values.Sum();
        var result = countByCategory.Select(kv => new
        {
            categoryName = categoryMap.TryGetValue(kv.Key, out var name) ? name : kv.Key,
            count = kv.Value,
            percentage = total > 0 ? Math.Round((double)kv.Value / total * 100, 1) : 0.0
        }).OrderByDescending(x => x.count).ToList();
        return Ok(result);
    }

    /// <summary>GET /api/borrow/top-borrowers?status=&month=&year= → [{userName, count}] (tối đa 5)</summary>
    [HttpGet("top-borrowers")]
    public async Task<IActionResult> TopBorrowers([FromQuery] int status = 0, [FromQuery] int month = 0, [FromQuery] int year = 0)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var filter = Builders<BorrowCard>.Filter.And(
            Builders<BorrowCard>.Filter.Gte(c => c.NgayMuon, start),
            Builders<BorrowCard>.Filter.Lt(c => c.NgayMuon, end),
            Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false));
        if (status != 0) filter &= Builders<BorrowCard>.Filter.Eq(c => c.TrangThai, status);
        var cards = await _ctx.BorrowCards.Find(filter).ToListAsync();
        var topGroups = cards.GroupBy(c => c.DocGiaId).OrderByDescending(g => g.Count()).Take(5).ToList();
        if (topGroups.Count == 0) return Ok(new List<object>());

        var userIds = topGroups.Select(g => g.Key).ToList();
        var users = await _ctx.Users.Find(u => userIds.Contains(u.Id!) && !u.IsDeleted).ToListAsync();
        var userMap = users.ToDictionary(u => u.Id!, u => u.HoTen);
        var result = topGroups.Select(g => new
        {
            userName = userMap.TryGetValue(g.Key, out var name) ? name : g.Key,
            count = g.Count()
        }).ToList();
        return Ok(result);
    }

    [HttpGet("{cardId}")]
    public async Task<IActionResult> GetById(string cardId)
    {
        var result = await _service.GetByIdAsync(cardId);
        return result == null ? NotFound() : Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Borrow([FromBody] BorrowCardCreateDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "system";
        var (ok, message) = await _service.CreateBorrowAsync(dto, userId);
        return ok ? Ok(new { message }) : BadRequest(new { message });
    }

    [HttpPut("return/{cardId}")]
    public async Task<IActionResult> Return(string cardId)
        => await _service.ReturnBookAsync(cardId) ? Ok(new { message = "Trả sách thành công" }) : NotFound();
}
