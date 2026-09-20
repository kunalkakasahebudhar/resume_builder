package auth

import (
	"resume_builder/internal/auth/models"
	"time"

	"gorm.io/gorm"
)

type repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) Repository {
	return &repository{db: db}
}

func (r *repository) CreateUser(user *models.User) error {
	return r.db.Create(user).Error
}

func (r *repository) FindUserByEmail(email string) (*models.User, error) {
	var user models.User
	err := r.db.Where("email = ?", email).First(&user).Error
	return &user, err
}

func (r *repository) FindUserByID(id uint) (*models.User, error) {
	var user models.User
	err := r.db.First(&user, id).Error
	return &user, err
}

func (r *repository) UpdateUser(user *models.User) error {
	return r.db.Save(user).Error
}

func (r *repository) CreateOTP(otp *models.OTP) error {
	return r.db.Create(otp).Error
}

func (r *repository) FindValidOTP(email, otp, otpType string) (*models.OTP, error) {
	var record models.OTP
	err := r.db.Where("email = ? AND otp = ? AND type = ? AND used = false AND expires_at > ?",
		email, otp, otpType, time.Now()).First(&record).Error
	return &record, err
}

func (r *repository) InvalidateOTPs(email, otpType string) error {
	return r.db.Model(&models.OTP{}).
		Where("email = ? AND type = ? AND used = false", email, otpType).
		Update("used", true).Error
}
