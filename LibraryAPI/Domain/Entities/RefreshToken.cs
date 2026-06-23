using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class RefreshToken : BaseEntity
{
    [BsonElement("user_id")]
    public string UserId { get; set; } = null!;
    [BsonElement("token")]
    public string Token { get; set; } = null!;
    [BsonElement("expires_at")]
    public DateTime ExpiresAt { get; set; }
    [BsonElement("is_revoked")]
    public bool IsRevoked { get; set; }
}
