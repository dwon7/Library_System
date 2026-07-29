using LibraryAPI.DTOs.InventoryCheck;
namespace LibraryAPI.Services;
public interface IInventoryCheckService
{
    Task<InventoryCheckResponseDto?> GetByIdAsync(string auditId);
    Task<InventoryCheckResponseDto> CreateAsync(InventoryCheckCreateDto dto, string userId);
    Task<(bool ok, string message)> CompleteInventoryAsync(string id, string userId);
    Task<int> GetCountByStatusAsync(int status);
    Task<List<InventoryCheckResponseDto>> GetListByStatusAsync(int status);
    Task<string> GenerateAuditIdAsync();
    Task<InventoryStatDto> GetStatisticsAsync(string inventoryId);
    // QR Scanner endpoints
    Task<int[]> GetAuditProgressAsync(string auditId);
    Task<int> ScanQRAsync(string auditId, string qrValue);
    Task<bool> UpdateBookConditionAsync(string auditId, string bookId, int conditionType);
    Task<List<AuditDetailResponseDto>> GetBooksByStatusAsync(string auditId, int status);
    Task<bool> DeleteAuditAsync(string auditId);
}
