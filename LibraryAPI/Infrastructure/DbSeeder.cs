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


        // 4. Tạo Index cho 3 Collection mới
        var categoryIndex = new CreateIndexModel<Category>(
            Builders<Category>.IndexKeys.Ascending(c => c.MaDanhMuc),
            new CreateIndexOptions { Unique = true });
        await _ctx.Categories.Indexes.CreateOneAsync(categoryIndex);

        var transactionIndex = new CreateIndexModel<StockTransaction>(
            Builders<StockTransaction>.IndexKeys.Ascending(t => t.MaGiaoDich),
            new CreateIndexOptions { Unique = true });
        await _ctx.StockTransactions.Indexes.CreateOneAsync(transactionIndex);

        // Index tìm kiếm phiếu theo ngày
        var transDateIndex = new CreateIndexModel<StockTransaction>(
            Builders<StockTransaction>.IndexKeys.Descending(t => t.NgayThucHien));
        await _ctx.StockTransactions.Indexes.CreateOneAsync(transDateIndex);

        var inventoryIndex = new CreateIndexModel<InventoryCheck>(
            Builders<InventoryCheck>.IndexKeys.Ascending(i => i.MaPhieuKiemKe),
            new CreateIndexOptions { Unique = true });
        await _ctx.InventoryChecks.Indexes.CreateOneAsync(inventoryIndex);

        // 5. Seed danh mục mẫu
        var hasCat = await _ctx.Categories.Find(_ => true).AnyAsync();
        if (!hasCat)
        {
            await _ctx.Categories.InsertManyAsync(new List<Category>
    {
        new Category
        {
            MaDanhMuc = "DM-CNTT",
            TenDanhMuc = "Công nghệ thông tin",
            MoTa = "Sách, giáo trình và tài liệu nghiên cứu về CNTT",
            ViTriKhuVuc = "Khu vực tầng 2 - Dãy kệ số 4"
        },
        new Category
        {
            MaDanhMuc = "DM-KTKT",
            TenDanhMuc = "Kinh tế - Kế toán",
            MoTa = "Tài liệu về kinh tế, tài chính, kế toán",
            ViTriKhuVuc = "Khu vực tầng 3 - Dãy kệ số 1"
        }
    });
        }

    }
}
