namespace LibraryAPI.DTOs.StockTransaction;

public class StockTransactionCreateDto
{
    public string MaGiaoDich { get; set; } = null!;
    public DateTime NgayThucHien { get; set; } = DateTime.UtcNow;
    public string CanBoPhuTrach { get; set; } = null!;
    public string? CanBoId { get; set; }
    public string TenDoiTac { get; set; } = null!;
    public string? MaSoThueHoacMssv { get; set; }
    public string? GhiChu { get; set; }
    public List<TransactionDetailDto> ChiTietGiaoDich { get; set; } = new();
}

public class TransactionDetailDto
{
    public string SachId { get; set; } = null!;
    public int SoLuong { get; set; }
    public decimal DonGia { get; set; }
}

public class StockTransactionResponseDto
{
    public string Id { get; set; } = null!;
    public string MaGiaoDich { get; set; } = null!;
    public int LoaiPhieu { get; set; }
    public string LoaiPhieuText { get; set; } = null!;
    public DateTime NgayThucHien { get; set; }
    public string CanBoPhuTrach { get; set; } = null!;
    public string TenDoiTac { get; set; } = null!;
    public decimal TongTien { get; set; }
    public string? GhiChu { get; set; }
    public int SoLuongDauSach { get; set; }
    public int TongSoLuongSach { get; set; }
}
