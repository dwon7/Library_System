using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
namespace LibraryAPI.Controllers;
[ApiController]
[Route("api/[controller]")]
public class DashboardController : ControllerBase
{
    private readonly MongoDbContext _ctx;
    public DashboardController(MongoDbContext ctx) => _ctx = ctx;

    /// <summary>GET /api/dashboard/borrow-by-year?year= → [{month, count}]</summary>
    [HttpGet("borrow-by-year")]
    public async Task<IActionResult> BorrowByYear([FromQuery] int year)
    {
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = new DateTime(year + 1, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var cards = await _ctx.BorrowCards
            .Find(c => c.NgayMuon >= start && c.NgayMuon < end && !c.IsDeleted)
            .ToListAsync();
        var monthMap = cards.GroupBy(c => c.NgayMuon.Month)
            .ToDictionary(g => g.Key, g => g.Count());
        var result = Enumerable.Range(1, 12)
            .Select(m => new { month = m, count = monthMap.TryGetValue(m, out var cnt) ? cnt : 0 })
            .ToList();
        return Ok(result);
    }

    /// <summary>GET /api/dashboard/category-ratio?month=&year= → [{categoryName, count, percentage}]</summary>
    [HttpGet("category-ratio")]
    public async Task<IActionResult> CategoryRatio([FromQuery] int month, [FromQuery] int year)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var cards = await _ctx.BorrowCards
            .Find(c => c.NgayMuon >= start && c.NgayMuon < end && !c.IsDeleted)
            .ToListAsync();
        var bookIds = cards.SelectMany(c => c.ChiTietMuon.Select(d => d.SachId)).Distinct().ToList();
        if (bookIds.Count == 0) return Ok(new List<object>());

        var books = await _ctx.Books.Find(b => bookIds.Contains(b.Id!) && !b.IsDeleted).ToListAsync();
        var categoryIds = books.Where(b => b.DanhMucId != null).Select(b => b.DanhMucId!).Distinct().ToList();
        var categories = await _ctx.Categories.Find(c => categoryIds.Contains(c.Id!) && !c.IsDeleted).ToListAsync();
        var categoryMap = categories.ToDictionary(c => c.Id!, c => c.TenDanhMuc);
        var bookCategoryMap = books.ToDictionary(b => b.Id!, b => b.DanhMucId ?? "unknown");

        var borrowCountByCategory = new Dictionary<string, int>();
        foreach (var card in cards)
        {
            foreach (var detail in card.ChiTietMuon)
            {
                if (bookCategoryMap.TryGetValue(detail.SachId, out var catId))
                {
                    borrowCountByCategory.TryGetValue(catId, out var cnt);
                    borrowCountByCategory[catId] = cnt + detail.SoLuong;
                }
            }
        }
        var total = borrowCountByCategory.Values.Sum();
        var result = borrowCountByCategory.Select(kv => new
        {
            categoryName = categoryMap.TryGetValue(kv.Key, out var name) ? name : kv.Key,
            count = kv.Value,
            percentage = total > 0 ? Math.Round((double)kv.Value / total * 100, 1) : 0.0
        }).OrderByDescending(x => x.count).ToList();
        return Ok(result);
    }

    /// <summary>GET /api/dashboard/borrow-status?month=&year= → {completed, borrowing, overdue}</summary>
    [HttpGet("borrow-status")]
    public async Task<IActionResult> BorrowStatus([FromQuery] int month, [FromQuery] int year)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var cards = await _ctx.BorrowCards
            .Find(c => c.NgayMuon >= start && c.NgayMuon < end && !c.IsDeleted)
            .ToListAsync();
        return Ok(new
        {
            completed = cards.Count(c => c.TrangThai == 1),
            borrowing = cards.Count(c => c.TrangThai == 2),
            overdue = cards.Count(c => c.TrangThai == 3)
        });
    }

    /// <summary>GET /api/dashboard/top-borrowers?month=&year= → [{fullName, totalBorrows}]</summary>
    [HttpGet("top-borrowers")]
    public async Task<IActionResult> TopBorrowers([FromQuery] int month, [FromQuery] int year)
    {
        if (month <= 0) month = DateTime.UtcNow.Month;
        if (year <= 0) year = DateTime.UtcNow.Year;
        var start = new DateTime(year, month, 1, 0, 0, 0, DateTimeKind.Utc);
        var end = start.AddMonths(1);
        var cards = await _ctx.BorrowCards
            .Find(c => c.NgayMuon >= start && c.NgayMuon < end && !c.IsDeleted)
            .ToListAsync();
        var topGroups = cards.GroupBy(c => c.DocGiaId)
            .OrderByDescending(g => g.Count())
            .Take(10)
            .ToList();
        if (topGroups.Count == 0) return Ok(new List<object>());

        var userIds = topGroups.Select(g => g.Key).ToList();
        var users = await _ctx.Users.Find(u => userIds.Contains(u.Id!) && !u.IsDeleted).ToListAsync();
        var userMap = users.ToDictionary(u => u.Id!, u => u.HoTen);
        var result = topGroups.Select(g => new
        {
            fullName = userMap.TryGetValue(g.Key, out var name) ? name : g.Key,
            totalBorrows = g.Count()
        }).ToList();
        return Ok(result);
    }
}
