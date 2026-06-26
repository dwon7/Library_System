using LibraryAPI.DTOs.Borrow;
namespace LibraryAPI.Services;
public interface IBorrowService
{
    Task<(bool ok, string message)> CreateBorrowAsync(BorrowCardCreateDto dto, string userId);
    Task<bool> ReturnBookAsync(string cardId);
    Task<int> GetDueTodayCountAsync();
    Task<int> GetCountByStatusAsync(int status);
    Task<List<BorrowCardResponseDto>> GetByStatusAsync(int status);
    Task<BorrowCardResponseDto?> GetByIdAsync(string cardId);
    Task<string> GenerateCardIdAsync();
}
