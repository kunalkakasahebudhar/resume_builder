package models

import (
	"time"
	"gorm.io/gorm"
)

type User struct {
	ID         uint           `gorm:"primaryKey;autoIncrement" json:"id"`
	Name       string         `gorm:"size:100;not null" json:"name"`
	Email      string         `gorm:"size:150;uniqueIndex;not null" json:"email"`
	Password   string         `gorm:"not null" json:"-"`
	Status     string         `gorm:"size:20;default:'active'" json:"status"`
	IsVerified bool           `gorm:"default:true" json:"is_verified"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `gorm:"index" json:"-"`
}

func (User) TableName() string { return "users" }

const (
	StatusActive  = "active"
	StatusPending = "pending"
)
