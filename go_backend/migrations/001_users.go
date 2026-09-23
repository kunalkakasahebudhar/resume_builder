package migrations

import (
	"resume_builder/internal/auth/models"
	"gorm.io/gorm"
)

func Migrate(db *gorm.DB) error {
	return db.AutoMigrate(&models.User{}, &models.UserOTP{})
}
