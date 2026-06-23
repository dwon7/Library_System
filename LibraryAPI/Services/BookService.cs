using AutoMapper;
using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Book;
using LibraryAPI.DTOs.Common;
using LibraryAPI.Repositories;
namespace LibraryAPI.Services;
public class BookService : IBookService
{
    private readonly IBookRepository _repo;
    private readonly IMapper _mapper;
    public BookService(IBookRepository repo, IMapper mapper) { _repo = repo; _mapper = mapper; }

    public async Task<PagedResult<BookResponseDto>> SearchAsync(string? keyword, string? theLoai, int? nam, int page, int pageSize)
    {
        var (items, total) = await _repo.SearchAsync(keyword, theLoai, nam, page, pageSize);
        return new PagedResult<BookResponseDto>
        {
            Items = _mapper.Map<List<BookResponseDto>>(items),
            Total = total,
            Page = page,
            PageSize = pageSize
        };
    }

    public async Task<BookResponseDto?> GetByIdAsync(string id)
    {
        var book = await _repo.GetByIdAsync(id);
        return book == null ? null : _mapper.Map<BookResponseDto>(book);
    }

    public async Task<BookResponseDto> CreateAsync(BookCreateDto dto, string userId)
    {
        var book = _mapper.Map<Book>(dto);
        book.SoLuongCon = dto.TongSoLuong;
        book.CreatedBy = userId;
        await _repo.CreateAsync(book);
        return _mapper.Map<BookResponseDto>(book);
    }

    public async Task<bool> UpdateAsync(string id, BookUpdateDto dto, string userId)
    {
        var book = await _repo.GetByIdAsync(id);
        if (book == null) return false;
        _mapper.Map(dto, book);
        book.UpdatedBy = userId;
        return await _repo.UpdateAsync(id, book);
    }

    public async Task<bool> DeleteAsync(string id, string userId) => await _repo.SoftDeleteAsync(id);
}
