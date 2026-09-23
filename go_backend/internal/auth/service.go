package auth

import (
	apperrors "resume_builder/common/errors"
	"resume_builder/common/utils"
	"resume_builder/internal/auth/models"
)

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo: repo}
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
	return nil
}

func (s *service) ResetPassword(req *models.ResetPasswordRequest) error {
	claims, err := utils.ValidateToken(req.Token)
	if err != nil {
		return apperrors.ErrTokenInvalid
	}

	user, err := s.repo.FindUserByEmail(claims.Email)
	if err != nil {
		return apperrors.ErrNotFound
	}

	hashed, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		return apperrors.ErrInternalServer
	}

	user.Password = hashed
	return s.repo.UpdateUser(user)
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
