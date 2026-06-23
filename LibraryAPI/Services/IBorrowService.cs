using LibraryAPI.Domain.Entities;
namespace LibraryAPI.Services;
public interface IBorrowService
{
    Task<(bool ok, string message)> CreateBorrowAsync(BorrowCard card, string userId);
    Task<bool> ReturnBookAsync(string cardId);
}

