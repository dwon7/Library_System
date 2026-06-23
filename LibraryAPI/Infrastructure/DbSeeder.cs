using LibraryAPI.Domain.Entities;
using MongoDB.Driver;
namespace LibraryAPI.Infrastructure;
public class DbSeeder
{
    private readonly MongoDbContext _ctx;
    public DbSeeder(MongoDbContext ctx) => _ctx = ctx;

    public async Task SeedAsync()
    {
        // 1. Tạo Unique Index
        var userIndex = new CreateIndexModel<User>(
            Builders<User>.IndexKeys.Ascending(u => u.Email),
            new CreateIndexOptions { Unique = true });
        await _ctx.Users.Indexes.CreateOneAsync(userIndex);

        var bookTextIndex = new CreateIndexModel<Book>(
            Builders<Book>.IndexKeys.Text(b => b.TenTaiLieu));
        await _ctx.Books.Indexes.CreateOneAsync(bookTextIndex);

        // 2. Seed Admin mặc định
        var adminExists = await _ctx.Users.Find(u => u.Email == "admin@library.com").AnyAsync();
        if (!adminExists)
        {
            await _ctx.Users.InsertOneAsync(new User
            {
                HoTen = "Quản trị viên",
                Email = "admin@library.com",
                Role = "Admin",
                MaDocGia = "ADMIN001",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin@123")
            });
        }

        // 3. Seed sách mẫu nếu chưa có
        var hasBook = await _ctx.Books.Find(_ => true).AnyAsync();
        if (!hasBook)
        {
            await _ctx.Books.InsertManyAsync(new List<Book>
            {
                new Book { MaSach="S001", TenTaiLieu="Lập trình C# cơ bản", TheLoai=new(){"Giáo trình"}, NamXuatBan=2023, LoaiTaiLieu="Sách giấy", TongSoLuong=5, SoLuongCon=5 },
                new Book { MaSach="S002", TenTaiLieu="MongoDB toàn tập", TheLoai=new(){"Cơ sở dữ liệu"}, NamXuatBan=2024, LoaiTaiLieu="Sách giấy", TongSoLuong=3, SoLuongCon=3 }
            });
        }
    }
}
