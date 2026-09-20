package auth

import (
	"resume_builder/internal/auth/models"
	"time"
)

type Repository interface {
	CreateUser(user *models.User) error
	FindUserByEmail(email string) (*models.User, error)
	FindUserByID(id uint) (*models.User, error)
	UpdateUser(user *models.User) error
	CreateOTP(otp *models.OTP) error
	FindValidOTP(email, otp, otpType string) (*models.OTP, error)
	InvalidateOTPs(email, otpType string) error
}

type Service interface {
	Register(req *models.RegisterRequest) error
	Login(req *models.LoginRequest) (*models.AuthResponse, error)
	VerifyEmail(req *models.VerifyEmailRequest) error
	ForgotPassword(req *models.ForgotPasswordRequest) error
	ResetPassword(req *models.ResetPasswordRequest) error
	RefreshToken(req *models.RefreshTokenRequest) (*models.AuthResponse, error)
}

type EmailService interface {
	SendOTP(toEmail, name, otp, otpType string) error
}

type OTPStore interface {
	Save(email, otp, otpType string, expiresAt time.Time) error
	Validate(email, otp, otpType string) bool
	Invalidate(email, otpType string) error
}
