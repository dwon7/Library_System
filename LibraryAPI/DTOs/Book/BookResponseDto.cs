namespace LibraryAPI.DTOs.Book
{
    public class BookResponseDto
    {
        public string Id { get; set; } = null!;
        public string MaSach { get; set; } = null!;
        public string TenTaiLieu { get; set; } = null!;
        public List<string> TheLoai { get; set; } = new();
        public int NamXuatBan { get; set; }
        public int SoLuongCon { get; set; }
    }

}
