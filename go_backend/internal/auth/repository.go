package auth

import (
	"resume_builder/internal/auth/models"
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

func (r *repository) SaveOTP(otp *models.UserOTP) error {
	return r.db.Create(otp).Error
}

func (r *repository) FindOTP(email, otp string) (*models.UserOTP, error) {
	var record models.UserOTP
	err := r.db.Where("email = ? AND otp = ?", email, otp).First(&record).Error
	return &record, err
}

func (r *repository) DeleteOTPsByEmail(email string) error {
	return r.db.Where("email = ?", email).Delete(&models.UserOTP{}).Error
}
