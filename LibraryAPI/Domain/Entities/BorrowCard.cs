using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class BorrowCard : BaseEntity
{
    [BsonElement("ma_phieu")]
    public string MaPhieu { get; set; } = null!;
    [BsonElement("doc_gia_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string DocGiaId { get; set; } = null!;
    [BsonElement("ngay_muon")]
    public DateTime NgayMuon { get; set; }
    [BsonElement("ngay_hen_tra")]
    public DateTime NgayHenTra { get; set; }
    [BsonElement("chi_tiet_muon")]
    public List<BorrowDetail> ChiTietMuon { get; set; } = new();
    [BsonElement("trang_thai_muon")]
    public string TrangThaiMuon { get; set; } = "Đang mượn";
}

public class BorrowDetail
{
    [BsonElement("sach_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string SachId { get; set; } = null!;
    [BsonElement("so_luong")]
    public int SoLuong { get; set; }
}

