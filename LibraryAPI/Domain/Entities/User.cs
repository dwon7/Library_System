using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class User : BaseEntity
{
    [BsonElement("ma_doc_gia")]
    public string MaDocGia { get; set; } = null!;
    [BsonElement("ho_ten")]
    public string HoTen { get; set; } = null!;
    [BsonElement("email")]
    public string Email { get; set; } = null!;
    [BsonElement("password_hash")]
    public string PasswordHash { get; set; } = null!;
    [BsonElement("role")]
    public string Role { get; set; } = "Member";
    [BsonElement("sdt")]
    public string? Sdt { get; set; }
    [BsonElement("chuyen_nganh")]
    public string? ChuyenNganh { get; set; }
}
