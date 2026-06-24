using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

/// <summary>
/// Danh mục sách — Collection: categories
/// Quan hệ: Book LINK sang Category qua trường danh_muc_id (1 Category - Nhiều Book)
/// </summary>
public class Category : BaseEntity
{
    [BsonElement("ma_danh_muc")]
    public string MaDanhMuc { get; set; } = null!;

    [BsonElement("ten_danh_muc")]
    public string TenDanhMuc { get; set; } = null!;

    [BsonElement("mo_ta")]
    public string? MoTa { get; set; }

    [BsonElement("vi_tri_khu_vuc")]
    public string? ViTriKhuVuc { get; set; }
}
