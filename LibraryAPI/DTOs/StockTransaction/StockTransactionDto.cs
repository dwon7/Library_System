namespace LibraryAPI.DTOs.StockTransaction;

public class StockTransactionCreateDto
{
    public string LedgerId { get; set; } = null!;
    public int LedgerType { get; set; }                 // 1=Import, 2=Export
    public DateTime? TransactionDate { get; set; }
    public string StaffInCharge { get; set; } = null!;
    public PartnerDto Partner { get; set; } = new();
    public List<LedgerDetailCreateDto> LedgerDetails { get; set; } = new();
    public decimal? GrandTotal { get; set; }
    public string? Notes { get; set; }
}

public class PartnerDto
{
    public string PartnerName { get; set; } = null!;
    public string? TaxOrStudentId { get; set; }
}

public class LedgerDetailCreateDto
{
    public string BookId { get; set; } = null!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalAmount { get; set; }
}

public class StockTransactionResponseDto
{
    public string LedgerId { get; set; } = null!;           // ma_giao_dich (e.g. NK-001)
    public int LedgerType { get; set; }                      // loai_phieu
    public DateTime TransactionDate { get; set; }            // ngay_thuc_hien
    public string StaffInCharge { get; set; } = null!;      // can_bo_phu_trach
    public PartnerResponseDto Partner { get; set; } = new();
    public List<LedgerDetailResponseDto> LedgerDetails { get; set; } = new();
    public decimal GrandTotal { get; set; }                  // tong_tien
    public string? Notes { get; set; }                       // ghi_chu
}

public class PartnerResponseDto
{
    public string PartnerName { get; set; } = null!;
    public string? TaxOrStudentId { get; set; }
}

public class LedgerDetailResponseDto
{
    public string BookId { get; set; } = null!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalAmount { get; set; }
}
