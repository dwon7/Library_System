namespace LibraryAPI.DTOs.Book;
public class BookCreateDto
{
    public string MaSach { get; set; } = null!;
    public string TenTaiLieu { get; set; } = null!;
    public List<string> TheLoai { get; set; } = new();
    public int NamXuatBan { get; set; }
    public string LoaiTaiLieu { get; set; } = null!;
    public int TongSoLuong { get; set; }
}
