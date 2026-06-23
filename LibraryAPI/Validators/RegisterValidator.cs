using FluentValidation;
using LibraryAPI.DTOs.Auth;
namespace LibraryAPI.Validators;
public class RegisterValidator : AbstractValidator<RegisterDto>
{
    public RegisterValidator()
    {
        RuleFor(x => x.HoTen).NotEmpty().WithMessage("Họ tên không được trống");
        RuleFor(x => x.Email).NotEmpty().EmailAddress().WithMessage("Email không hợp lệ");
        RuleFor(x => x.Password).MinimumLength(8).WithMessage("Mật khẩu tối thiểu 8 ký tự");
        RuleFor(x => x.Sdt).Matches(@"^[0-9]{9,11}$").When(x => !string.IsNullOrEmpty(x.Sdt))
            .WithMessage("Số điện thoại không hợp lệ");
    }
}
