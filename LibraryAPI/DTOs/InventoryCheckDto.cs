namespace LibraryAPI.DTOs.InventoryCheck;

public class InventoryCheckCreateDto
{
    public string AuditId { get; set; } = null!;
    public DateTime? AuditDate { get; set; }
    public List<AuditBoardMemberDto> AuditBoard { get; set; } = new();
    public int Status { get; set; } = 2;
    public List<AuditDetailDto> AuditDetails { get; set; } = new();
    public int? TotalAuditedQuantity { get; set; }
    public string? Notes { get; set; }
}

public class AuditBoardMemberDto
{
    public string FullName { get; set; } = null!;
    public string Role { get; set; } = null!;
}

public class AuditDetailDto
{
    public string BookId { get; set; } = null!;
    public int Quantity { get; set; }
    public int ConditionType { get; set; } = 1;   // 1=good, 2=damaged, 3=lost
}

public class InventoryCheckResponseDto
{
    public string AuditId { get; set; } = null!;          // ma_phieu_kiem_ke (e.g. KK-001)
    public DateTime AuditDate { get; set; }               // ngay_kiem_ke
    public List<AuditBoardMemberResponseDto> AuditBoard { get; set; } = new();
    public int Status { get; set; }                        // 1=completed, 2=in-progress
    public List<AuditDetailResponseDto> AuditDetails { get; set; } = new();
    public int TotalAuditedQuantity { get; set; }         // tong_so_luong_kiem_ke
    public string? Notes { get; set; }                    // ghi_chu
}

public class AuditBoardMemberResponseDto
{
    public string FullName { get; set; } = null!;
    public string Role { get; set; } = null!;
}

public class AuditDetailResponseDto
{
    public string BookId { get; set; } = null!;
    public int Quantity { get; set; }
    public int ConditionType { get; set; }
}

public class InventoryStatDto
{
    public string AuditId { get; set; } = null!;
    public int TotalQuantity { get; set; }
    public int GoodQuantity { get; set; }
    public int DamagedQuantity { get; set; }
    public int LostQuantity { get; set; }
    public int UniqueBookCount { get; set; }
}

public class ScanQRDto
{
    public string QrValue { get; set; } = null!;
}

public class UpdateBookConditionDto
{
    public int ConditionType { get; set; }
}
