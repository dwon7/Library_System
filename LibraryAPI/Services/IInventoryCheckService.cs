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
}
