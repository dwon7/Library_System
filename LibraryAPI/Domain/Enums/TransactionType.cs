namespace LibraryAPI.Domain.Enums;

public static class TransactionType
{
    public const int Import = 1; // Nhập kho
    public const int Export = 2; // Xuất kho
}

public static class InventoryStatus
{
    public const int Completed = 1;   // Đã hoàn thành
    public const int InProgress = 2;  // Chưa hoàn thành
}

public static class BookCondition
{
    public const int Good = 1;    // Còn sử dụng
    public const int Damaged = 2; // Rách, nát
    public const int Lost = 3;    // Mất
}
