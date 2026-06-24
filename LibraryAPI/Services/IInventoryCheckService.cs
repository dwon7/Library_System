using LibraryAPI.DTOs.InventoryCheck;

namespace LibraryAPI.Services;

public interface IInventoryCheckService
{
    /// <summary>Lấy tất cả phiếu kiểm kê</summary>
    Task<List<InventoryCheckResponseDto>> GetAllAsync();

    /// <summary>Lấy phiếu kiểm kê theo ID</summary>
    Task<InventoryCheckResponseDto?> GetByIdAsync(string id);

    /// <summary>Tạo phiếu kiểm kê mới</summary>
    Task<InventoryCheckResponseDto> CreateAsync(
        InventoryCheckCreateDto dto, string userId);

    /// <summary>
    /// Hoàn thành kiểm kê — dùng MongoDB Transaction:
    /// 1. Cập nhật trạng thái phiếu = Hoàn thành
    /// 2. Cập nhật SoLuongCon trong books theo kết quả thực tế
    /// 3. Đánh dấu sách mất/hỏng
    /// </summary>
    Task<(bool ok, string message)> CompleteInventoryAsync(
        string id, string userId);

    /// <summary>Lọc theo trạng thái</summary>
    Task<List<InventoryCheckResponseDto>> GetByTrangThaiAsync(int trangThai);

    /// <summary>Thống kê: Tổng số sách mất/hỏng theo kỳ kiểm kê</summary>
    Task<InventoryStatDto> GetStatisticsAsync(string inventoryId);
}
