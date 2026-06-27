using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Borrow;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;
namespace LibraryAPI.Services;
public class BorrowService : IBorrowService
{
    private readonly MongoDbContext _ctx;
    public BorrowService(MongoDbContext ctx) => _ctx = ctx;

    public async Task<(bool ok, string message)> CreateBorrowAsync(BorrowCardCreateDto dto, string userId)
    {
        // Pre-check stock for all books before modifying anything
        foreach (var item in dto.BorrowDetails)
        {
            var book = await _ctx.Books
                .Find(b => b.Id == item.BookId && !b.IsDeleted)
                .FirstOrDefaultAsync();
            if (book == null || book.SoLuongCon < item.Quantity)
                return (false, $"Sách {item.BookId} không đủ số lượng");
        }
        // Deduct stock sequentially
        foreach (var item in dto.BorrowDetails)
        {
            var f = Builders<Book>.Filter.And(
                Builders<Book>.Filter.Eq(b => b.Id, item.BookId),
                Builders<Book>.Filter.Gte(b => b.SoLuongCon, item.Quantity));
            var u = Builders<Book>.Update.Inc(b => b.SoLuongCon, -item.Quantity);
            var result = await _ctx.Books.UpdateOneAsync(f, u);
            if (result.ModifiedCount == 0)
                return (false, $"Sách {item.BookId} không đủ số lượng");
        }
        var card = new BorrowCard
        {
            MaPhieu = dto.CardId,
            DocGiaId = dto.UserId,
            NgayMuon = dto.BorrowDate ?? DateTime.UtcNow,
            NgayHenTra = dto.DueDate ?? DateTime.UtcNow.AddDays(14),
            TrangThai = 2,
            ChiTietMuon = dto.BorrowDetails.Select(d => new BorrowDetail
            {
                SachId = d.BookId,
                SoLuong = d.Quantity
            }).ToList(),
            CreatedBy = userId
        };
        await _ctx.BorrowCards.InsertOneAsync(card);
        return (true, "Tạo phiếu mượn thành công");
    }

    public async Task<bool> ReturnBookAsync(string cardId)
    {
        var card = await _ctx.BorrowCards
            .Find(c => c.MaPhieu == cardId && !c.IsDeleted)
            .FirstOrDefaultAsync();
        if (card == null) return false;
        foreach (var item in card.ChiTietMuon)
        {
            var upd = Builders<Book>.Update.Inc(b => b.SoLuongCon, item.SoLuong);
            await _ctx.Books.UpdateOneAsync(b => b.Id == item.SachId, upd);
        }
        var setStatus = Builders<BorrowCard>.Update.Set(c => c.TrangThai, 1);
        await _ctx.BorrowCards.UpdateOneAsync(c => c.MaPhieu == cardId, setStatus);
        return true;
    }

    public async Task<int> GetDueTodayCountAsync()
    {
        var today = DateTime.UtcNow.Date;
        var tomorrow = today.AddDays(1);
        return (int)await _ctx.BorrowCards.CountDocumentsAsync(c =>
            c.NgayHenTra >= today && c.NgayHenTra < tomorrow &&
            c.TrangThai == 2 && !c.IsDeleted);
    }

    public async Task<int> GetCountByStatusAsync(int status)
    {
        var filter = status == 0
            ? Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false)
            : Builders<BorrowCard>.Filter.And(
                Builders<BorrowCard>.Filter.Eq(c => c.TrangThai, status),
                Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false));
        return (int)await _ctx.BorrowCards.CountDocumentsAsync(filter);
    }

    public async Task<List<BorrowCardResponseDto>> GetByStatusAsync(int status)
    {
        var filter = status == 0
            ? Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false)
            : Builders<BorrowCard>.Filter.And(
                Builders<BorrowCard>.Filter.Eq(c => c.TrangThai, status),
                Builders<BorrowCard>.Filter.Eq(c => c.IsDeleted, false));
        var cards = await _ctx.BorrowCards.Find(filter)
            .SortByDescending(c => c.NgayMuon).ToListAsync();
        return await BuildResponsesAsync(cards);
    }

    public async Task<BorrowCardResponseDto?> GetByIdAsync(string cardId)
    {
        var card = await _ctx.BorrowCards
            .Find(c => c.MaPhieu == cardId && !c.IsDeleted)
            .FirstOrDefaultAsync();
        if (card == null) return null;
        return await BuildResponseAsync(card);
    }

    public async Task<string> GenerateCardIdAsync()
    {
        var count = await _ctx.BorrowCards.CountDocumentsAsync(_ => true);
        return $"PM-{(count + 1):D3}";
    }

    private async Task<List<BorrowCardResponseDto>> BuildResponsesAsync(List<BorrowCard> cards)
    {
        if (cards.Count == 0) return new();
        var userIds = cards.Select(c => c.DocGiaId).Distinct().ToList();
        var bookIds = cards.SelectMany(c => c.ChiTietMuon.Select(d => d.SachId)).Distinct().ToList();
        var users = await _ctx.Users.Find(u => userIds.Contains(u.Id!) && !u.IsDeleted).ToListAsync();
        var books = await _ctx.Books.Find(b => bookIds.Contains(b.Id!) && !b.IsDeleted).ToListAsync();
        var userMap = users.ToDictionary(u => u.Id!, u => u.HoTen);
        var bookMap = books.ToDictionary(b => b.Id!, b => b);
        return cards.Select(c => BuildFromMaps(c, userMap, bookMap)).ToList();
    }

    private async Task<BorrowCardResponseDto> BuildResponseAsync(BorrowCard card)
    {
        var user = await _ctx.Users
            .Find(u => u.Id == card.DocGiaId && !u.IsDeleted)
            .FirstOrDefaultAsync();
        var bookIds = card.ChiTietMuon.Select(d => d.SachId).Distinct().ToList();
        var books = await _ctx.Books.Find(b => bookIds.Contains(b.Id!) && !b.IsDeleted).ToListAsync();
        var userMap = user != null ? new Dictionary<string, string> { [user.Id!] = user.HoTen } : new();
        var bookMap = books.ToDictionary(b => b.Id!, b => b);
        return BuildFromMaps(card, userMap, bookMap);
    }

    private static BorrowCardResponseDto BuildFromMaps(
        BorrowCard c,
        Dictionary<string, string> userMap,
        Dictionary<string, Book> bookMap) => new()
    {
        CardId = c.MaPhieu,
        UserId = c.DocGiaId,
        UserName = userMap.TryGetValue(c.DocGiaId, out var name) ? name : null,
        BorrowDate = c.NgayMuon,
        DueDate = c.NgayHenTra,
        Status = c.TrangThai,
        BorrowDetails = c.ChiTietMuon.Select(d => new BorrowDetailResponseDto
        {
            BookId = d.SachId,
            BookName = bookMap.TryGetValue(d.SachId, out var book) ? book.TenTaiLieu : null,
            Quantity = d.SoLuong
        }).ToList()
    };
}
