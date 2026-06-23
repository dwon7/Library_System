using AutoMapper;
using LibraryAPI.Domain.Entities;
using LibraryAPI.DTOs.Book;
namespace LibraryAPI.Mappings;
public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<BookCreateDto, Book>();
        CreateMap<BookUpdateDto, Book>();
        CreateMap<Book, BookResponseDto>();
    }
}
