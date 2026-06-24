using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

/// <summary>
/// Phiếu nhập/xuất sách — Collection: stock_transactions
/// Quan hệ:
///   - LINK sang Book qua chi_tiet_giao_dich[].sach_id
///   - EMBED doi_tac (thông tin đối tác ít biến động, nhúng trực tiếp)
///   - LINK sang User qua can_bo_id (cán bộ phụ trách)
/// </summary>

public class StockTransaction : BaseEntity
{
    [BsonElement("ma_giao_dich")]
    public string MaGiaoDich { get; set; } = null!;

    /// <summary>1: Nhập kho, 2: Xuất kho</summary>
    [BsonElement("loai_phieu")]
    public int LoaiPhieu { get; set; }

    [BsonElement("ngay_thuc_hien")]
    public DateTime NgayThucHien { get; set; } = DateTime.UtcNow;

    /// <summary>LINK sang Collection users — cán bộ thực hiện</summary>
    [BsonElement("can_bo_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? CanBoId { get; set; }

    [BsonElement("can_bo_phu_trach")]
    public string CanBoPhuTrach { get; set; } = null!;

    /// <summary>EMBED — Thông tin đối tác (nhà cung cấp hoặc sinh viên)</summary>
    [BsonElement("doi_tac")]
    public DoiTacInfo DoiTac { get; set; } = new();

    /// <summary>EMBED mảng chi tiết + LINK sang books qua sach_id</summary>
    [BsonElement("chi_tiet_giao_dich")]
    public List<TransactionDetail> ChiTietGiaoDich { get; set; } = new();

    [BsonElement("tong_tien")]
    public decimal TongTien { get; set; }

    [BsonElement("ghi_chu")]
    public string? GhiChu { get; set; }
}

/// <summary>EMBED — Thông tin đối tác (không tách collection riêng)</summary>
public class DoiTacInfo
{
    [BsonElement("ten_doi_tac")]
    public string TenDoiTac { get; set; } = null!;

    [BsonElement("ma_so_thue_hoac_mssv")]
    public string? MaSoThueHoacMssv { get; set; }
}

/// <summary>EMBED trong StockTransaction + LINK sang Book</summary>
public class TransactionDetail
{
    /// <summary>LINK sang Collection books</summary>
    [BsonElement("sach_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string SachId { get; set; } = null!;

    [BsonElement("so_luong")]
    public int SoLuong { get; set; }

    [BsonElement("don_gia")]
    public decimal DonGia { get; set; }

    [BsonElement("thanh_tien")]
    public decimal ThanhTien { get; set; }
}
