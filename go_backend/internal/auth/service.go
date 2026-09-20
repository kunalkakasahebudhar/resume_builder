package auth

import (
	apperrors "resume_builder/common/errors"
	"resume_builder/common/utils"
	"resume_builder/common/config"
	"resume_builder/internal/auth/models"
	"time"

	"gorm.io/gorm"
)

type service struct {
	repo  Repository
	email EmailService
}

func NewService(repo Repository, email EmailService) Service {
	return &service{repo: repo, email: email}
}

func (s *service) Register(req *models.RegisterRequest) error {
	existing, err := s.repo.FindUserByEmail(req.Email)
	if err == nil && existing.ID != 0 {
		return apperrors.ErrEmailExists
	}

	hashed, err := utils.HashPassword(req.Password)
	if err != nil {
		return apperrors.ErrInternalServer
	}

	user := &models.User{
		Name:     req.Name,
		Email:    req.Email,
		Password: hashed,
		Status:   models.StatusPending,
	}
	if err := s.repo.CreateUser(user); err != nil {
		return apperrors.ErrInternalServer
	}

	return s.sendOTP(user, models.OTPTypeEmailVerify)
}

func (s *service) Login(req *models.LoginRequest) (*models.AuthResponse, error) {
	user, err := s.repo.FindUserByEmail(req.Email)
	if err != nil {
		return nil, apperrors.ErrInvalidCredentials
	}

	if !utils.CheckPassword(user.Password, req.Password) {
		return nil, apperrors.ErrInvalidCredentials
	}

	if !user.IsVerified {
		return nil, apperrors.ErrAccountNotVerified
	}

	return s.generateAuthResponse(user)
}

func (s *service) VerifyEmail(req *models.VerifyEmailRequest) error {
	otp, err := s.repo.FindValidOTP(req.Email, req.OTP, models.OTPTypeEmailVerify)
	if err != nil {
		return apperrors.ErrOTPInvalid
	}

	user, err := s.repo.FindUserByID(otp.UserID)
	if err != nil {
		return apperrors.ErrNotFound
	}

	user.IsVerified = true
	user.Status = models.StatusActive
	if err := s.repo.UpdateUser(user); err != nil {
		return apperrors.ErrInternalServer
	}

	return s.repo.InvalidateOTPs(req.Email, models.OTPTypeEmailVerify)
}

func (s *service) ForgotPassword(req *models.ForgotPasswordRequest) error {
	user, err := s.repo.FindUserByEmail(req.Email)
	if err != nil {
		// Don't reveal if email exists
		return nil
	}
	return s.sendOTP(user, models.OTPTypePasswordReset)
}

func (s *service) ResetPassword(req *models.ResetPasswordRequest) error {
	otp, err := s.repo.FindValidOTP(req.Email, req.OTP, models.OTPTypePasswordReset)
	if err != nil {
		return apperrors.ErrOTPInvalid
	}

	user, err := s.repo.FindUserByID(otp.UserID)
	if err != nil {
		return apperrors.ErrNotFound
	}

	hashed, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		return apperrors.ErrInternalServer
	}

	user.Password = hashed
	if err := s.repo.UpdateUser(user); err != nil {
		return apperrors.ErrInternalServer
	}

	return s.repo.InvalidateOTPs(req.Email, models.OTPTypePasswordReset)
}

func (s *service) RefreshToken(req *models.RefreshTokenRequest) (*models.AuthResponse, error) {
	claims, err := utils.ValidateToken(req.RefreshToken)
	if err != nil {
		return nil, apperrors.ErrTokenInvalid
	}

	user, err := s.repo.FindUserByID(claims.UserID)
	if err != nil {
		return nil, apperrors.ErrNotFound
	}

	return s.generateAuthResponse(user)
}

func (s *service) sendOTP(user *models.User, otpType string) error {
	_ = s.repo.InvalidateOTPs(user.Email, otpType)

	otp, err := utils.GenerateOTP()
	if err != nil {
		return apperrors.ErrInternalServer
	}

	record := &models.OTP{
		UserID:    user.ID,
		Email:     user.Email,
		OTP:       otp,
		Type:      otpType,
		ExpiresAt: time.Now().Add(time.Duration(config.App.OTPExpiryMinutes) * time.Minute),
	}
	if err := s.repo.CreateOTP(record); err != nil {
		return apperrors.ErrInternalServer
	}

	return s.email.SendOTP(user.Email, user.Name, otp, otpType)
}

func (s *service) generateAuthResponse(user *models.User) (*models.AuthResponse, error) {
	accessToken, err := utils.GenerateAccessToken(user.ID, user.Email)
	if err != nil {
		return nil, apperrors.ErrInternalServer
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID, user.Email)
	if err != nil {
		return nil, apperrors.ErrInternalServer
	}

	return &models.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         toUserInfo(user),
	}, nil
}

// Ensure gorm.ErrRecordNotFound is handled
var _ = gorm.ErrRecordNotFound
