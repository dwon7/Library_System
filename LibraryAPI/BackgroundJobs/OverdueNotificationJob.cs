using LibraryAPI.Infrastructure;
using MongoDB.Driver;
namespace LibraryAPI.BackgroundJobs;
public class OverdueNotificationJob
{
    private readonly MongoDbContext _ctx;
    private readonly ILogger<OverdueNotificationJob> _logger;
    public OverdueNotificationJob(MongoDbContext ctx, ILogger<OverdueNotificationJob> logger)
    { _ctx = ctx; _logger = logger; }

    public async Task ScanOverdueAsync()
    {
        var overdue = await _ctx.BorrowCards
            .Find(c => c.TrangThaiMuon == "Đang mượn" && c.NgayHenTra < DateTime.UtcNow)
            .ToListAsync();
        _logger.LogInformation($"Có {overdue.Count} phiếu mượn quá hạn cần nhắc nhở");
        // TODO: ghi vào collection notifications hoặc gửi email
    }
}
