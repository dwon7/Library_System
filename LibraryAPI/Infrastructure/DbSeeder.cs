using LibraryAPI.Domain.Entities;
using LibraryAPI.Domain.Enums;
using MongoDB.Driver;
namespace LibraryAPI.Infrastructure;
public class DbSeeder
{
    private readonly MongoDbContext _ctx;
    public DbSeeder(MongoDbContext ctx) => _ctx = ctx;

    public async Task SeedAsync()
    {
        await CreateIndexesAsync();
        await SeedUsersAsync();
        var catIds = await SeedCategoriesAsync();
        var bookIds = await SeedBooksAsync(catIds);
        var userIds = await GetMemberUserIdsAsync();
        await SeedBorrowCardsAsync(bookIds, userIds);
        await SeedStockTransactionsAsync(bookIds);
        await SeedInventoryChecksAsync(bookIds);
    }

    private async Task CreateIndexesAsync()
    {
        // Each CreateOne/CreateMany is wrapped individually so one pre-existing index
        // with a different name doesn't abort all the others.

        // Users
        await TryCreateIndex(() => _ctx.Users.Indexes.CreateOneAsync(new CreateIndexModel<User>(
            Builders<User>.IndexKeys.Ascending(u => u.Email),
            new CreateIndexOptions { Unique = true })));
        await TryCreateIndex(() => _ctx.Users.Indexes.CreateOneAsync(new CreateIndexModel<User>(
            Builders<User>.IndexKeys.Ascending(u => u.MaDocGia),
            new CreateIndexOptions { Unique = true })));

        // Books
        await TryCreateIndex(() => _ctx.Books.Indexes.CreateOneAsync(new CreateIndexModel<Book>(
            Builders<Book>.IndexKeys.Ascending(b => b.MaSach),
            new CreateIndexOptions { Unique = true })));
        await TryCreateIndex(() => _ctx.Books.Indexes.CreateOneAsync(new CreateIndexModel<Book>(
            Builders<Book>.IndexKeys.Ascending(b => b.DanhMucId))));
        await TryCreateIndex(() => _ctx.Books.Indexes.CreateOneAsync(new CreateIndexModel<Book>(
            Builders<Book>.IndexKeys.Text(b => b.TenTaiLieu))));

        // Categories
        await TryCreateIndex(() => _ctx.Categories.Indexes.CreateOneAsync(new CreateIndexModel<Category>(
            Builders<Category>.IndexKeys.Ascending(c => c.MaDanhMuc),
            new CreateIndexOptions { Unique = true })));

        // BorrowCards
        await TryCreateIndex(() => _ctx.BorrowCards.Indexes.CreateOneAsync(new CreateIndexModel<BorrowCard>(
            Builders<BorrowCard>.IndexKeys.Ascending(c => c.MaPhieu),
            new CreateIndexOptions { Unique = true })));
        await TryCreateIndex(() => _ctx.BorrowCards.Indexes.CreateOneAsync(new CreateIndexModel<BorrowCard>(
            Builders<BorrowCard>.IndexKeys.Ascending(c => c.DocGiaId))));
        await TryCreateIndex(() => _ctx.BorrowCards.Indexes.CreateOneAsync(new CreateIndexModel<BorrowCard>(
            Builders<BorrowCard>.IndexKeys.Ascending(c => c.TrangThai))));
        await TryCreateIndex(() => _ctx.BorrowCards.Indexes.CreateOneAsync(new CreateIndexModel<BorrowCard>(
            Builders<BorrowCard>.IndexKeys.Ascending(c => c.NgayHenTra))));
        await TryCreateIndex(() => _ctx.BorrowCards.Indexes.CreateOneAsync(new CreateIndexModel<BorrowCard>(
            Builders<BorrowCard>.IndexKeys.Ascending(c => c.TrangThai).Descending(c => c.NgayMuon))));

        // StockTransactions
        await TryCreateIndex(() => _ctx.StockTransactions.Indexes.CreateOneAsync(new CreateIndexModel<StockTransaction>(
            Builders<StockTransaction>.IndexKeys.Ascending(t => t.MaGiaoDich),
            new CreateIndexOptions { Unique = true })));
        await TryCreateIndex(() => _ctx.StockTransactions.Indexes.CreateOneAsync(new CreateIndexModel<StockTransaction>(
            Builders<StockTransaction>.IndexKeys.Ascending(t => t.LoaiPhieu))));
        await TryCreateIndex(() => _ctx.StockTransactions.Indexes.CreateOneAsync(new CreateIndexModel<StockTransaction>(
            Builders<StockTransaction>.IndexKeys.Ascending(t => t.LoaiPhieu).Descending(t => t.NgayThucHien))));

        // InventoryChecks
        await TryCreateIndex(() => _ctx.InventoryChecks.Indexes.CreateOneAsync(new CreateIndexModel<InventoryCheck>(
            Builders<InventoryCheck>.IndexKeys.Ascending(i => i.MaPhieuKiemKe),
            new CreateIndexOptions { Unique = true })));
        await TryCreateIndex(() => _ctx.InventoryChecks.Indexes.CreateOneAsync(new CreateIndexModel<InventoryCheck>(
            Builders<InventoryCheck>.IndexKeys.Ascending(i => i.TrangThai))));
        await TryCreateIndex(() => _ctx.InventoryChecks.Indexes.CreateOneAsync(new CreateIndexModel<InventoryCheck>(
            Builders<InventoryCheck>.IndexKeys.Ascending(i => i.TrangThai).Descending(i => i.NgayKiemKe))));
    }

    private static async Task TryCreateIndex(Func<Task> create)
    {
        try { await create(); }
        catch (MongoCommandException ex) when (ex.CodeName == "IndexOptionsConflict" || ex.Code == 85 || ex.Code == 86) { }
    }

    private async Task SeedUsersAsync()
    {
        var adminExists = await _ctx.Users.Find(u => u.Email == "admin@library.com").AnyAsync();
        if (!adminExists)
        {
            await _ctx.Users.InsertOneAsync(new User
            {
                MaDocGia = "ADMIN001",
                HoTen = "Quản trị viên",
                Email = "admin@library.com",
                Role = "Admin",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin@123")
            });
        }

        var members = new[]
        {
            ("DG001", "Nguyễn Văn An", "an@library.vn", "Công nghệ thông tin", "0901234567"),
            ("DG002", "Trần Thị Bình", "binh@library.vn", "Kinh tế", "0902345678"),
            ("DG003", "Lê Văn Cường", "cuong@library.vn", "Văn học", "0903456789"),
            ("DG004", "Phạm Thị Dung", "dung@library.vn", "Ngoại ngữ", "0904567890"),
            ("DG005", "Hoàng Văn Em", "em@library.vn", "Công nghệ thông tin", "0905678901"),
        };
        foreach (var (ma, hoTen, email, chuyenNganh, sdt) in members)
        {
            var exists = await _ctx.Users.Find(u => u.Email == email).AnyAsync();
            if (!exists)
            {
                await _ctx.Users.InsertOneAsync(new User
                {
                    MaDocGia = ma,
                    HoTen = hoTen,
                    Email = email,
                    Role = "Member",
                    ChuyenNganh = chuyenNganh,
                    Sdt = sdt,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Member@123")
                });
            }
        }
    }

    private async Task<Dictionary<string, string>> SeedCategoriesAsync()
    {
        var catIds = new Dictionary<string, string>();
        var cats = new[]
        {
            ("DM-CNTT", "Công nghệ thông tin", "Sách, giáo trình về CNTT, lập trình, CSDL", "Tầng 2 - Dãy kệ 4"),
            ("DM-KTKT", "Kinh tế - Kế toán", "Tài liệu về kinh tế, tài chính, kế toán", "Tầng 3 - Dãy kệ 1"),
            ("DM-VH", "Văn học", "Sách văn học, truyện, thơ", "Tầng 1 - Dãy kệ 2"),
            ("DM-NN", "Ngoại ngữ", "Sách học ngoại ngữ", "Tầng 1 - Dãy kệ 3"),
        };
        foreach (var (ma, ten, moTa, viTri) in cats)
        {
            var existing = await _ctx.Categories.Find(c => c.MaDanhMuc == ma).FirstOrDefaultAsync();
            if (existing == null)
            {
                var cat = new Category { MaDanhMuc = ma, TenDanhMuc = ten, MoTa = moTa, ViTriKhuVuc = viTri };
                await _ctx.Categories.InsertOneAsync(cat);
                catIds[ma] = cat.Id!;
            }
            else
            {
                catIds[ma] = existing.Id!;
            }
        }
        return catIds;
    }

    private async Task<List<string>> SeedBooksAsync(Dictionary<string, string> catIds)
    {
        var bookIds = new List<string>();
        var books = new[]
        {
            ("S001", "Lập trình C# cơ bản", "DM-CNTT", 2023, "NXB ĐHQG", "Sách giấy", 10,
                new[] { ("Nguyễn Thanh Sơn", "PGS.TS") }),
            ("S002", "MongoDB toàn tập", "DM-CNTT", 2024, "NXB Thông tin", "Sách giấy", 5,
                new[] { ("Trần Minh Tuấn", "ThS") }),
            ("S003", "Flutter & GetX thực chiến", "DM-CNTT", 2024, "NXB KHKT", "Sách giấy", 8,
                new[] { ("Lê Văn Dũng", "ThS"), ("Phạm Anh Tuấn", "TS") }),
            ("S004", "Python cho khoa học dữ liệu", "DM-CNTT", 2023, "NXB ĐHQG", "Ebook", 0,
                new[] { ("Hoàng Thị Lan", "TS") }),
            ("S005", "Kinh tế học vi mô", "DM-KTKT", 2022, "NXB Giáo dục", "Sách giấy", 12,
                new[] { ("Nguyễn Văn Hùng", "GS.TS") }),
            ("S006", "Nguyên lý kế toán", "DM-KTKT", 2023, "NXB Tài chính", "Sách giấy", 7,
                new[] { ("Trần Thị Minh", "PGS.TS") }),
            ("S007", "Truyện Kiều", "DM-VH", 2020, "NXB Văn học", "Sách giấy", 20,
                new[] { ("Nguyễn Du", "") }),
            ("S008", "Số đỏ", "DM-VH", 2021, "NXB Văn học", "Sách giấy", 15,
                new[] { ("Vũ Trọng Phụng", "") }),
            ("S009", "English Grammar In Use", "DM-NN", 2022, "Cambridge", "Sách giấy", 25,
                new[] { ("Raymond Murphy", "PhD") }),
            ("S010", "TOEIC 990", "DM-NN", 2023, "NXB ĐHQG", "Sách giấy", 18,
                new[] { ("Kim Daeyeon", "MA") }),
        };

        foreach (var (maSach, ten, catMa, nam, nxb, loai, soLuong, tacGias) in books)
        {
            var existing = await _ctx.Books.Find(b => b.MaSach == maSach).FirstOrDefaultAsync();
            if (existing == null)
            {
                var book = new Book
                {
                    MaSach = maSach,
                    TenTaiLieu = ten,
                    DanhMucId = catIds.TryGetValue(catMa, out var catId) ? catId : null,
                    NamXuatBan = nam,
                    NhaXuatBan = nxb,
                    LoaiTaiLieu = loai,
                    TongSoLuong = soLuong,
                    SoLuongCon = soLuong,
                    TheLoai = new List<string> { catMa },
                    TacGia = tacGias.Select(t => new Author { HoTen = t.Item1, HocHam = t.Item2 }).ToList()
                };
                await _ctx.Books.InsertOneAsync(book);
                bookIds.Add(book.Id!);
            }
            else
            {
                // Update existing books to add danh_muc_id if missing
                if (existing.DanhMucId == null && catIds.TryGetValue(catMa, out var catId))
                {
                    var upd = Builders<Book>.Update.Set(b => b.DanhMucId, catId);
                    await _ctx.Books.UpdateOneAsync(b => b.Id == existing.Id, upd);
                }
                bookIds.Add(existing.Id!);
            }
        }
        return bookIds;
    }

    private async Task<List<string>> GetMemberUserIdsAsync()
    {
        var members = await _ctx.Users.Find(u => u.Role == "Member" && !u.IsDeleted).ToListAsync();
        return members.Select(u => u.Id!).ToList();
    }

    private async Task SeedBorrowCardsAsync(List<string> bookIds, List<string> userIds)
    {
        if (bookIds.Count == 0 || userIds.Count == 0) return;
        var hasCards = await _ctx.BorrowCards.Find(_ => true).AnyAsync();
        if (hasCards) return;

        var now = DateTime.UtcNow;
        var cards = new List<BorrowCard>
        {
            new BorrowCard
            {
                MaPhieu = "PM-001",
                DocGiaId = userIds[0],
                NgayMuon = now.AddDays(-20),
                NgayHenTra = now.AddDays(-6),
                TrangThai = BorrowStatus.Returned,  // Đã trả
                ChiTietMuon = new List<BorrowDetail>
                {
                    new BorrowDetail { SachId = bookIds[0], SoLuong = 1 },
                    new BorrowDetail { SachId = bookIds[1], SoLuong = 1 }
                }
            },
            new BorrowCard
            {
                MaPhieu = "PM-002",
                DocGiaId = userIds[1 % userIds.Count],
                NgayMuon = now.AddDays(-10),
                NgayHenTra = now.AddDays(4),
                TrangThai = BorrowStatus.Borrowing,  // Đang mượn
                ChiTietMuon = new List<BorrowDetail>
                {
                    new BorrowDetail { SachId = bookIds[2 % bookIds.Count], SoLuong = 1 }
                }
            },
            new BorrowCard
            {
                MaPhieu = "PM-003",
                DocGiaId = userIds[2 % userIds.Count],
                NgayMuon = now.AddDays(-30),
                NgayHenTra = now.AddDays(-16),
                TrangThai = BorrowStatus.Overdue,   // Quá hạn
                ChiTietMuon = new List<BorrowDetail>
                {
                    new BorrowDetail { SachId = bookIds[4 % bookIds.Count], SoLuong = 2 }
                }
            },
            new BorrowCard
            {
                MaPhieu = "PM-004",
                DocGiaId = userIds[0],
                NgayMuon = now.AddDays(-5),
                NgayHenTra = now.AddDays(9),
                TrangThai = BorrowStatus.Borrowing,  // Đang mượn
                ChiTietMuon = new List<BorrowDetail>
                {
                    new BorrowDetail { SachId = bookIds[5 % bookIds.Count], SoLuong = 1 }
                }
            },
            new BorrowCard
            {
                MaPhieu = "PM-005",
                DocGiaId = userIds[3 % userIds.Count],
                NgayMuon = now.AddDays(-15),
                NgayHenTra = now.AddDays(-1),  // Hạn ngày hôm qua
                TrangThai = BorrowStatus.Overdue,
                ChiTietMuon = new List<BorrowDetail>
                {
                    new BorrowDetail { SachId = bookIds[6 % bookIds.Count], SoLuong = 1 }
                }
            }
        };

        // Reduce SoLuongCon for borrowing/overdue cards
        foreach (var card in cards.Where(c => c.TrangThai != BorrowStatus.Returned))
        {
            foreach (var detail in card.ChiTietMuon)
            {
                var f = Builders<Book>.Filter.And(
                    Builders<Book>.Filter.Eq(b => b.Id, detail.SachId),
                    Builders<Book>.Filter.Gte(b => b.SoLuongCon, detail.SoLuong));
                var u = Builders<Book>.Update.Inc(b => b.SoLuongCon, -detail.SoLuong);
                await _ctx.Books.UpdateOneAsync(f, u);
            }
        }

        await _ctx.BorrowCards.InsertManyAsync(cards);
    }

    private async Task SeedStockTransactionsAsync(List<string> bookIds)
    {
        if (bookIds.Count == 0) return;
        var hasTransactions = await _ctx.StockTransactions.Find(_ => true).AnyAsync();
        if (hasTransactions) return;

        var now = DateTime.UtcNow;
        var transactions = new List<StockTransaction>
        {
            new StockTransaction
            {
                MaGiaoDich = "NK-001",
                LoaiPhieu = TransactionType.Import,
                NgayThucHien = now.AddDays(-60),
                CanBoPhuTrach = "Nguyễn Thị Thu",
                DoiTac = new DoiTacInfo { TenDoiTac = "NXB Giáo dục Việt Nam", MaSoThueHoacMssv = "MST-123456" },
                ChiTietGiaoDich = new List<TransactionDetail>
                {
                    new TransactionDetail { SachId = bookIds[0], SoLuong = 10, DonGia = 85000, ThanhTien = 850000 },
                    new TransactionDetail { SachId = bookIds[1], SoLuong = 5, DonGia = 120000, ThanhTien = 600000 }
                },
                TongTien = 1450000,
                GhiChu = "Nhập sách đầu kỳ",
                CreatedBy = "system"
            },
            new StockTransaction
            {
                MaGiaoDich = "XK-001",
                LoaiPhieu = TransactionType.Export,
                NgayThucHien = now.AddDays(-30),
                CanBoPhuTrach = "Trần Văn Bình",
                DoiTac = new DoiTacInfo { TenDoiTac = "Sinh viên K67", MaSoThueHoacMssv = "SV-K67" },
                ChiTietGiaoDich = new List<TransactionDetail>
                {
                    new TransactionDetail { SachId = bookIds[2 % bookIds.Count], SoLuong = 2, DonGia = 95000, ThanhTien = 190000 }
                },
                TongTien = 190000,
                GhiChu = "Xuất sách hỏng",
                CreatedBy = "system"
            }
        };
        await _ctx.StockTransactions.InsertManyAsync(transactions);
    }

    private async Task SeedInventoryChecksAsync(List<string> bookIds)
    {
        if (bookIds.Count == 0) return;
        var hasChecks = await _ctx.InventoryChecks.Find(_ => true).AnyAsync();
        if (hasChecks) return;

        var now = DateTime.UtcNow;
        var checks = new List<InventoryCheck>
        {
            new InventoryCheck
            {
                MaPhieuKiemKe = "KK-001",
                NgayKiemKe = now.AddDays(-45),
                HoiDongKiemKe = new List<KiemKeMember>
                {
                    new KiemKeMember { HoTen = "Nguyễn Thị Thu", VaiTro = "Trưởng ban" },
                    new KiemKeMember { HoTen = "Lê Văn Minh", VaiTro = "Thành viên" }
                },
                TrangThai = InventoryStatus.Completed,
                KetQuaChiTiet = new List<InventoryDetail>
                {
                    new InventoryDetail { SachId = bookIds[0], SoLuong = 9, TinhTrangSach = BookCondition.Good },
                    new InventoryDetail { SachId = bookIds[0], SoLuong = 1, TinhTrangSach = BookCondition.Damaged },
                    new InventoryDetail { SachId = bookIds[1], SoLuong = 5, TinhTrangSach = BookCondition.Good }
                },
                TongSoLuongKiemKe = 15,
                GhiChu = "Kiểm kê định kỳ quý 1",
                CreatedBy = "system"
            },
            new InventoryCheck
            {
                MaPhieuKiemKe = "KK-002",
                NgayKiemKe = now.AddDays(-5),
                HoiDongKiemKe = new List<KiemKeMember>
                {
                    new KiemKeMember { HoTen = "Phạm Thị Hoa", VaiTro = "Trưởng ban" }
                },
                TrangThai = InventoryStatus.InProgress,
                KetQuaChiTiet = new List<InventoryDetail>
                {
                    new InventoryDetail { SachId = bookIds[2 % bookIds.Count], SoLuong = 8, TinhTrangSach = BookCondition.Good }
                },
                TongSoLuongKiemKe = 8,
                GhiChu = "Kiểm kê đột xuất",
                CreatedBy = "system"
            }
        };
        await _ctx.InventoryChecks.InsertManyAsync(checks);
    }
}
