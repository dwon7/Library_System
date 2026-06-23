using LibraryAPI.Domain.Entities;
using LibraryAPI.Infrastructure;
using MongoDB.Driver;
namespace LibraryAPI.Services;
public class BorrowService : IBorrowService
{
    private readonly MongoDbContext _ctx;
    public BorrowService(MongoDbContext ctx) => _ctx = ctx;

    public async Task<(bool ok, string message)> CreateBorrowAsync(BorrowCard card, string userId)
    {
        using var session = await _ctx.Client.StartSessionAsync();
        session.StartTransaction();
        try
        {
            foreach (var item in card.ChiTietMuon)
            {
                var filter = Builders<Book>.Filter.And(
                    Builders<Book>.Filter.Eq(b => b.Id, item.SachId),
                    Builders<Book>.Filter.Gte(b => b.SoLuongCon, item.SoLuong));
                var update = Builders<Book>.Update.Inc(b => b.SoLuongCon, -item.SoLuong);
                var result = await _ctx.Books.FindOneAndUpdateAsync(session, filter, update);
                if (result == null)
                {
                    await session.AbortTransactionAsync();
                    return (false, $"Sách {item.SachId} không đủ số lượng");
                }
            }
            card.CreatedBy = userId;
            card.TrangThaiMuon = "Đang mượn";
            await _ctx.BorrowCards.InsertOneAsync(session, card);
            await session.CommitTransactionAsync();
            return (true, "Tạo phiếu mượn thành công");
        }
        catch
        {
            await session.AbortTransactionAsync();
            return (false, "Lỗi giao dịch, đã rollback");
        }
    }

    public async Task<bool> ReturnBookAsync(string cardId)
    {
        using var session = await _ctx.Client.StartSessionAsync();
        session.StartTransaction();
        try
        {
            var card = await _ctx.BorrowCards.Find(session, c => c.Id == cardId).FirstOrDefaultAsync();
            if (card == null) { await session.AbortTransactionAsync(); return false; }
            foreach (var item in card.ChiTietMuon)
            {
                var update = Builders<Book>.Update.Inc(b => b.SoLuongCon, item.SoLuong);
                await _ctx.Books.UpdateOneAsync(session, b => b.Id == item.SachId, update);
            }
            var setStatus = Builders<BorrowCard>.Update.Set(c => c.TrangThaiMuon, "Đã trả sách");
            await _ctx.BorrowCards.UpdateOneAsync(session, c => c.Id == cardId, setStatus);
            await session.CommitTransactionAsync();
            return true;
        }
        catch { await session.AbortTransactionAsync(); return false; }
    }
}
