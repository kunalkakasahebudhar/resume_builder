package models

import (
	"resume_builder/common/constants"
	"time"

	"gorm.io/gorm"
)

type User struct {
	ID         uint           `gorm:"primaryKey;autoIncrement" json:"id"`
	Name       string         `gorm:"size:100;not null" json:"name"`
	Email      string         `gorm:"size:150;uniqueIndex;not null" json:"email"`
	Password   string         `gorm:"not null" json:"-"`
	Status     string         `gorm:"size:20;default:'pending'" json:"status"`
	IsVerified bool           `gorm:"default:false" json:"is_verified"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `gorm:"index" json:"-"`
}

func (User) TableName() string { return "users" }

type OTP struct {
	ID        uint      `gorm:"primaryKey;autoIncrement"`
	UserID    uint      `gorm:"not null;index"`
	Email     string    `gorm:"size:150;not null;index"`
	OTP       string    `gorm:"size:6;not null"`
	Type      string    `gorm:"size:30;not null"` // email_verify, password_reset
	ExpiresAt time.Time `gorm:"not null"`
	Used      bool      `gorm:"default:false"`
	CreatedAt time.Time
}

func (OTP) TableName() string { return "otps" }

const (
	OTPTypeEmailVerify  = "email_verify"
	OTPTypePasswordReset = "password_reset"
	StatusActive        = constants.StatusActive
	StatusPending       = constants.StatusPending
)
