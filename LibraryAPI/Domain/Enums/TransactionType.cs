namespace LibraryAPI.Domain.Enums;

public static class BorrowStatus { 
    public const int Returned = 1; 
    public const int Borrowing = 2; 
    public const int Overdue = 3; 
}

public static class TransactionType { 
    public const int Import = 1; 
    public const int Export = 2; 
}

public static class InventoryStatus { 
    public const int Completed = 1; 
    public const int InProgress = 2; 
}

public static class BookCondition {
    public const int Good = 1;
    public const int Damaged = 2;
    public const int Lost = 3;
    public const int NotInventoried = 4;  // Chưa kiểm kê — trạng thái khởi tạo khi tạo phiếu
}
