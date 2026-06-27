using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class BorrowCard : BaseEntity
{
    [BsonElement("ma_phieu")] public string MaPhieu { get; set; } = null!;  // PM-XXX
    // LINK -> users
    [BsonElement("doc_gia_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string DocGiaId { get; set; } = null!;
    [BsonElement("ngay_muon")] public DateTime NgayMuon { get; set; }
    [BsonElement("ngay_hen_tra")] public DateTime NgayHenTra { get; set; }
    [BsonElement("ngay_tra_thuc_te")] public DateTime? NgayTraThucTe { get; set; }
    // EMBED array + moi item LINK -> books qua sach_id
    [BsonElement("chi_tiet_muon")] public List<BorrowDetail> ChiTietMuon { get; set; } = new();
    /// <summary>1=Da tra, 2=Dang muon, 3=Qua han</summary>
    [BsonElement("trang_thai")] public int TrangThai { get; set; } = 2;
}

public class BorrowDetail
{
    // LINK -> books
    [BsonElement("sach_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string SachId { get; set; } = null!;
    [BsonElement("so_luong")] public int SoLuong { get; set; }
}

