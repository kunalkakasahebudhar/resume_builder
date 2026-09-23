package auth

import (
	"resume_builder/internal/auth/models"
)

func toUserInfo(u *models.User) models.UserInfo {
	return models.UserInfo{
		ID:         u.ID,
		FullName:   u.FullName,
		Email:      u.Email,
		IsVerified: u.IsVerified,
		Status:     u.Status,
	}
}
