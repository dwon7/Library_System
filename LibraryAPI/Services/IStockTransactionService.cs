using LibraryAPI.DTOs.StockTransaction;

namespace LibraryAPI.Services;

public interface IStockTransactionService
{
    /// <summary>Lấy tất cả phiếu nhập/xuất</summary>
    Task<List<StockTransactionResponseDto>> GetAllAsync();

    /// <summary>Lấy phiếu theo ID</summary>
    Task<StockTransactionResponseDto?> GetByIdAsync(string id);

    /// <summary>
    /// Tạo phiếu nhập kho — dùng MongoDB Transaction:
    /// 1. Tạo phiếu nhập
    /// 2. Tăng SoLuongCon và TongSoLuong trong books
    /// </summary>
    Task<(bool ok, string message, StockTransactionResponseDto? data)>
        CreateImportAsync(StockTransactionCreateDto dto, string userId);

    /// <summary>
    /// Tạo phiếu xuất kho — dùng MongoDB Transaction:
    /// 1. Kiểm tra SoLuongCon đủ không
    /// 2. Tạo phiếu xuất
    /// 3. Giảm SoLuongCon và TongSoLuong trong books
    /// </summary>
    Task<(bool ok, string message, StockTransactionResponseDto? data)>
        CreateExportAsync(StockTransactionCreateDto dto, string userId);

    /// <summary>Lọc theo loại phiếu (1: Nhập, 2: Xuất)</summary>
    Task<List<StockTransactionResponseDto>> GetByLoaiPhieuAsync(int loaiPhieu);

    /// <summary>Lọc theo khoảng thời gian</summary>
    Task<List<StockTransactionResponseDto>> GetByDateRangeAsync(
        DateTime from, DateTime to);
}
