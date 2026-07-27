using LibraryAPI.DTOs.StockTransaction;
namespace LibraryAPI.Services;
public interface IStockTransactionService
{
    Task<StockTransactionResponseDto?> GetByIdAsync(string ledgerId);
    Task<(bool ok, string message, StockTransactionResponseDto? data)> CreateImportAsync(StockTransactionCreateDto dto, string userId);
    Task<(bool ok, string message, StockTransactionResponseDto? data)> CreateExportAsync(StockTransactionCreateDto dto, string userId);
    Task<int> GetCountByTypeAsync(int ledgerType);
    Task<List<StockTransactionResponseDto>> GetListByTypeAsync(int ledgerType);
    Task<string> GenerateLedgerIdAsync(int ledgerType);
    Task<bool> DeleteAsync(string ledgerId);
}
