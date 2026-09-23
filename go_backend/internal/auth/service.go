package auth

import (
	apperrors "resume_builder/common/errors"
	"resume_builder/common/config"
	"resume_builder/common/utils"
	"resume_builder/internal/auth/models"
	"time"
)

type service struct {
	repo     Repository
	emailSvc EmailService
}

func NewService(repo Repository, emailSvc EmailService) Service {
	return &service{repo: repo, emailSvc: emailSvc}
}

func (s *service) Register(req *models.RegisterRequest) (*models.AuthResponse, error) {
	existing, err := s.repo.FindUserByEmail(req.Email)
	if err == nil && existing.ID != 0 {
		return nil, apperrors.ErrEmailExists
	}

	hashed, err := utils.HashPassword(req.Password)
	if err != nil {
		return nil, apperrors.ErrInternalServer
	}

	user := &models.User{
		FullName:   req.FullName,
		Email:      req.Email,
		Password:   hashed,
		Status:     models.StatusActive,
		IsVerified: true,
	}
	if err := s.repo.CreateUser(user); err != nil {
		return nil, apperrors.ErrInternalServer
	}

	return s.generateAuthResponse(user)
}

func (s *service) Login(req *models.LoginRequest) (*models.AuthResponse, error) {
	user, err := s.repo.FindUserByEmail(req.Email)
	if err != nil {
		return nil, apperrors.ErrInvalidCredentials
	}

	if !utils.CheckPassword(user.Password, req.Password) {
		return nil, apperrors.ErrInvalidCredentials
	}

	return s.generateAuthResponse(user)
}

func (s *service) ForgotPassword(req *models.ForgotPasswordRequest) error {
	_, err := s.repo.FindUserByEmail(req.Email)
	if err != nil {
		return apperrors.ErrNotFound
	}

	otp, err := utils.GenerateOTP()
	if err != nil {
		return apperrors.ErrInternalServer
	}

	// delete old OTPs for this email
	_ = s.repo.DeleteOTPsByEmail(req.Email)

	record := &models.UserOTP{
		Email:     req.Email,
		OTP:       otp,
		ExpiresAt: time.Now().Add(time.Duration(config.App.OTPExpiryMinutes) * time.Minute),
	}
	if err := s.repo.SaveOTP(record); err != nil {
		return apperrors.ErrInternalServer
	}

	if err := s.emailSvc.SendOTP(req.Email, otp); err != nil {
		return apperrors.ErrInternalServer
	}

	return nil
}

func (s *service) ResetPassword(req *models.ResetPasswordRequest) error {
	record, err := s.repo.FindOTP(req.Email, req.OTP)
	if err != nil {
		return apperrors.ErrTokenInvalid
	}

	if time.Now().After(record.ExpiresAt) {
		_ = s.repo.DeleteOTPsByEmail(req.Email)
		return apperrors.ErrTokenInvalid
	}

	user, err := s.repo.FindUserByEmail(req.Email)
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

	_ = s.repo.DeleteOTPsByEmail(req.Email)
	return nil
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

func (s *service) Logout() error {
	return nil
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
