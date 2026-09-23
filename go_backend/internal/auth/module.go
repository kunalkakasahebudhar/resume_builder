package auth

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Bootstrap(rg *gin.RouterGroup, db *gorm.DB) {
	repo := NewRepository(db)
	emailSvc := NewEmailService()
	svc := NewService(repo, emailSvc)
	handler := NewHandler(svc)
	RegisterRoutes(rg, handler)
}
