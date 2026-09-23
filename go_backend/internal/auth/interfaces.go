package auth

import "resume_builder/internal/auth/models"

type Repository interface {
	CreateUser(user *models.User) error
	FindUserByEmail(email string) (*models.User, error)
	FindUserByID(id uint) (*models.User, error)
	UpdateUser(user *models.User) error
	SaveOTP(otp *models.UserOTP) error
	FindOTP(email, otp string) (*models.UserOTP, error)
	DeleteOTPsByEmail(email string) error
}

type Service interface {
	Register(req *models.RegisterRequest) (*models.AuthResponse, error)
	Login(req *models.LoginRequest) (*models.AuthResponse, error)
	ForgotPassword(req *models.ForgotPasswordRequest) error
	ResetPassword(req *models.ResetPasswordRequest) error
	RefreshToken(req *models.RefreshTokenRequest) (*models.AuthResponse, error)
	Logout() error
}
