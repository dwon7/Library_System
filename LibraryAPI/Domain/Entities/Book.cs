using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class Book : BaseEntity
{
    [BsonElement("ma_sach")]
    public string MaSach { get; set; } = null!;

    [BsonElement("ten_tai_lieu")]
    public string TenTaiLieu { get; set; } = null!;

    [BsonElement("the_loai")]
    public List<string> TheLoai { get; set; } = new();

    [BsonElement("nam_xuat_ban")]
    public int NamXuatBan { get; set; }

    [BsonElement("nha_xuat_ban")]
    public string? NhaXuatBan { get; set; }

    [BsonElement("tac_gia")]
    public List<Author> TacGia { get; set; } = new();

    [BsonElement("loai_tai_lieu")]
    public string LoaiTaiLieu { get; set; } = null!;

    [BsonElement("tong_so_luong")]
    public int TongSoLuong { get; set; }

    [BsonElement("so_luong_con")]
    public int SoLuongCon { get; set; }

    [BsonElement("danh_muc_id")]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? DanhMucId { get; set; }

}

public class Author
{
    [BsonElement("ho_ten")]
    public string HoTen { get; set; } = null!;
    [BsonElement("hoc_ham")]
    public string? HocHam { get; set; }
}
