namespace LibraryAPI.DTOs.InventoryCheck;

public class InventoryCheckCreateDto
{
    public string MaPhieuKiemKe { get; set; } = null!;
    public DateTime NgayKiemKe { get; set; }
    public string? GhiChu { get; set; }
    public List<HoiDongDto> HoiDong { get; set; } = new();
    public List<InventoryDetailDto> KetQua { get; set; } = new();
}

public class HoiDongDto
{
    public string HoTen { get; set; } = null!;
    public string VaiTro { get; set; } = null!;
}

public class InventoryDetailDto
{
    public string SachId { get; set; } = null!;
    public int SoLuong { get; set; }
    public int TinhTrangSach { get; set; } = 1;
}

public class InventoryCheckResponseDto
{
    public string Id { get; set; } = null!;
    public string MaPhieuKiemKe { get; set; } = null!;
    public DateTime NgayKiemKe { get; set; }
    public int TrangThai { get; set; }
    public string TrangThaiText { get; set; } = null!;
    public int TongSoLuongKiemKe { get; set; }
    public int SoThanhVienHoiDong { get; set; }
    public string? GhiChu { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class InventoryStatDto
{
    public string MaPhieuKiemKe { get; set; } = null!;
    public int TongSoLuong { get; set; }
    public int SoLuongConDung { get; set; }
    public int SoLuongHong { get; set; }
    public int SoLuongMat { get; set; }
    public int SoDauSachKiemKe { get; set; }
}
