using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Book;
using LibraryAPI.DTOs.Common;
using LibraryAPI.Repositories;
namespace LibraryAPI.Services;
public class BookService : IBookService
{
    private readonly IBookRepository _repo;
    public BookService(IBookRepository repo) => _repo = repo;

    public async Task<PagedResult<BookResponseDto>> SearchAsync(string? keyword, string? categoryId, int page, int pageSize)
    {
        var (items, total) = await _repo.SearchAsync(keyword, categoryId, page, pageSize);
        return new PagedResult<BookResponseDto>
        {
            Items = items.Select(MapToDto).ToList(),
            Total = total,
            Page = page,
            PageSize = pageSize
        };
    }

    public async Task<BookResponseDto?> GetByIdAsync(string id)
    {
        var book = await _repo.GetByIdAsync(id);
        return book == null ? null : MapToDto(book);
    }

    public async Task<BookResponseDto> CreateAsync(BookCreateDto dto, string userId)
    {
        var qty = dto.GetTotalQuantity();
        var book = new Book
        {
            MaSach = $"SACH-{Guid.NewGuid().ToString("N")[..6].ToUpper()}",
            TenTaiLieu = dto.Title,
            DanhMucId = dto.CategoryId,
            NamXuatBan = dto.PublicationYear,
            NhaXuatBan = dto.Publisher,
            TacGia = dto.Authors.Select(a => new Author { HoTen = a.FullName, HocHam = a.Degree }).ToList(),
            LoaiTaiLieu = dto.DocumentType ?? "Sách giấy",
            TongSoLuong = qty,
            SoLuongCon = qty,
            CreatedBy = userId
        };
        await _repo.CreateAsync(book);
        return MapToDto(book);
    }

    public async Task<bool> UpdateAsync(string id, BookUpdateDto dto, string userId)
    {
        var book = await _repo.GetByIdAsync(id);
        if (book == null) return false;
        var qty = dto.GetTotalQuantity();
        book.TenTaiLieu = dto.Title;
        book.DanhMucId = dto.CategoryId;
        book.NamXuatBan = dto.PublicationYear;
        book.NhaXuatBan = dto.Publisher;
        book.TacGia = dto.Authors?.Select(a => new Author { HoTen = a.FullName, HocHam = a.Degree }).ToList() ?? book.TacGia;
        book.LoaiTaiLieu = dto.DocumentType ?? book.LoaiTaiLieu;
        if (qty > 0) book.TongSoLuong = qty;
        book.UpdatedBy = userId;
        return await _repo.UpdateAsync(id, book);
    }

    public async Task<bool> DeleteAsync(string id, string userId) => await _repo.SoftDeleteAsync(id);

    public static BookResponseDto MapToDto(Book b) => new()
    {
        BookId = b.Id!,
        BookCode = b.MaSach,
        Title = b.TenTaiLieu,
        CategoryId = b.DanhMucId,
        PublicationYear = b.NamXuatBan,
        Publisher = b.NhaXuatBan,
        Authors = b.TacGia.Select(a => new AuthorResponseDto { FullName = a.HoTen, Degree = a.HocHam }).ToList(),
        DocumentType = b.LoaiTaiLieu,
        PhysicalInfo = new PhysicalInfoDto { TotalQuantity = b.TongSoLuong, AvailableQuantity = b.SoLuongCon },
        Status = b.SoLuongCon > 0 ? "available" : "unavailable"
    };
}
