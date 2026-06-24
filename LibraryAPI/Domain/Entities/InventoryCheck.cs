using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

/// <summary>
/// Phiếu kiểm kê sách — Collection: inventory_checks
/// Quan hệ:
///   - EMBED hoi_dong_kiem_ke (danh sách cố định, ít thay đổi)
///   - LINK sang Book qua ket_qua_chi_tiet[].sach_id
/// </summary>
public class InventoryCheck : BaseEntity
{
    [BsonElement("ma_phieu_kiem_ke")]
    public string MaPhieuKiemKe { get; set; } = null!;

    [BsonElement("ngay_kiem_ke")]
    public DateTime NgayKiemKe { get; set; }

    /// <summary>EMBED — Hội đồng kiểm kê (nhúng vì ít biến động)</summary>
    [BsonElement("hoi_dong_kiem_ke")]
    public List<KiemKeMember> HoiDongKiemKe { get; set; } = new();

    /// <summary>1: Đã hoàn thành, 2: Chưa hoàn thành</summary>
    [BsonElement("trang_thai")]
    public int TrangThai { get; set; } = 2;

    /// <summary>EMBED mảng kết quả + LINK sang books qua sach_id</summary>
    [BsonElement("ket_qua_chi_tiet")]
    public List<InventoryDetail> KetQuaChiTiet { get; set; } = new();

    [BsonElement("tong_so_luong_kiem_ke")]
    public int TongSoLuongKiemKe { get; set; }

    [BsonElement("ghi_chu")]
    public string? GhiChu { get; set; }
}

/// <summary>EMBED — Thành viên hội đồng kiểm kê</summary>
public class KiemKeMember
{
    [BsonElement("ho_ten")]
    public string HoTen { get; set; } = null!;

    [BsonElement("vai_tro")]
    public string VaiTro { get; set; } = null!;
}

/// <summary>EMBED trong InventoryCheck + LINK sang Book</summary>
public class InventoryDetail
{
    /// <summary>LINK sang Collection books</summary>
    [BsonElement("sach_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string SachId { get; set; } = null!;

    [BsonElement("so_luong")]
    public int SoLuong { get; set; }

    /// <summary>1: Còn sử dụng, 2: Rách/nát, 3: Mất</summary>
    [BsonElement("tinh_trang_sach")]
    public int TinhTrangSach { get; set; } = 1;
}
