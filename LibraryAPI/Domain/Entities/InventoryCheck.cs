using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

/// <summary>
/// Phieu kiem ke sach — Collection: inventory_checks
/// EMBED: hoi_dong_kiem_ke (danh sach co dinh theo phieu)
/// LINK: ket_qua_chi_tiet[].sach_id -> books
/// </summary>
public class InventoryCheck : BaseEntity
{
    [BsonElement("ma_phieu_kiem_ke")] 
    public string MaPhieuKiemKe { get; set; } = null!;  // KK-XXX
    [BsonElement("ngay_kiem_ke")] 
    public DateTime NgayKiemKe { get; set; }
    // EMBED — Hoi dong co dinh, khong can tra cuu rieng
    [BsonElement("hoi_dong_kiem_ke")] 
    public List<KiemKeMember> HoiDongKiemKe { get; set; } = new();
    /// <summary>1=Da hoan thanh, 2=Chua hoan thanh</summary>
    [BsonElement("trang_thai")] public int 
    TrangThai { get; set; } = 2;
    // EMBED array + LINK -> books
    [BsonElement("ket_qua_chi_tiet")] 
    public List<InventoryDetail> KetQuaChiTiet { get; set; } = new();
    [BsonElement("tong_so_luong_kiem_ke")] 
    public int TongSoLuongKiemKe { get; set; }
    [BsonElement("ghi_chu")] 
    public string? GhiChu { get; set; }
}
public class KiemKeMember { 
    public string HoTen { get; set; } = null!; 
    public string VaiTro { get; set; } = null!; 
}

public class InventoryDetail
{
    [BsonElement("sach_id")][BsonRepresentation(BsonType.ObjectId)] 
    public string SachId { get; set; } = null!;
    [BsonElement("so_luong")] public int SoLuong { get; set; }
    /// <summary>1=Con su dung, 2=Rach/nat, 3=Mat</summary>
    [BsonElement("tinh_trang_sach")] public int TinhTrangSach { get; set; } = 1;
}
