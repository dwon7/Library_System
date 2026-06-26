using LibraryAPI.Domain.Entities;
using MongoDB.Bson.Serialization.Attributes;

using MongoDB.Bson;

/// <summary>
/// Phieu nhap/xuat kho — Collection: stock_transactions
/// EMBED: doi_tac (it bien dong, gan voi phieu)
/// LINK: can_bo_id -> users, chi_tiet[].sach_id -> books
/// </summary>
public class StockTransaction : BaseEntity
{
    [BsonElement("ma_giao_dich")] 
    public string MaGiaoDich { get; set; } = null!;  // NK-XXX / XK-XXX
    [BsonElement("loai_phieu")] 
    public int LoaiPhieu { get; set; }  // 1=Nhap, 2=Xuat
    [BsonElement("ngay_thuc_hien")]
    public DateTime NgayThucHien { get; set; } = DateTime.UtcNow;
    // LINK -> users
    [BsonElement("can_bo_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? CanBoId { get; set; }
    [BsonElement("can_bo_phu_trach")] 
    public string CanBoPhuTrach { get; set; } = null!;
    // EMBED — thong tin doi tac nha cung cap / sinh vien
    [BsonElement("doi_tac")]
    public DoiTacInfo DoiTac { get; set; } = new();
    // EMBED array + LINK -> books
    [BsonElement("chi_tiet_giao_dich")] 
    public List<TransactionDetail> ChiTietGiaoDich { get; set; } = new();
    [BsonElement("tong_tien")] 
    public decimal TongTien { get; set; }
    [BsonElement("ghi_chu")] 
    public string? GhiChu { get; set; }
}
public class DoiTacInfo { 
    public string TenDoiTac { get; set; } = null!;
    public string? MaSoThueHoacMssv { get; set; }
}
public class TransactionDetail
{
    [BsonElement("sach_id")][BsonRepresentation(BsonType.ObjectId)] 
    public string SachId { get; set; } = null!;
    [BsonElement("so_luong")] 
    public int SoLuong { get; set; }
    [BsonElement("don_gia")] 
    public decimal DonGia { get; set; }
    [BsonElement("thanh_tien")] 
    public decimal ThanhTien { get; set; }
}
