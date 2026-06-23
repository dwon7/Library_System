using MongoDB.Bson.Serialization.Attributes;

namespace LibraryAPI.Domain.Entities;

public class AuditLog : BaseEntity
{
    [BsonElement("user_id")]
    public string? UserId { get; set; }
    [BsonElement("action")]
    public string Action { get; set; } = null!;
    [BsonElement("entity")]
    public string Entity { get; set; } = null!;
    [BsonElement("entity_id")]
    public string? EntityId { get; set; }
    [BsonElement("timestamp")]
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
