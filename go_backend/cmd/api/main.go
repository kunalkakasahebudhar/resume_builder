package main

import (
	"log"
	"resume_builder/common/config"
	"resume_builder/common/database"
	"resume_builder/common/middleware"
	"resume_builder/internal/auth"
	"resume_builder/migrations"

	"github.com/gin-gonic/gin"
)

func main() {
	config.Load()
	database.Connect()

	if err := migrations.Migrate(database.DB); err != nil {
		log.Fatalf("Migration failed: %v", err)
	}

	if config.App.AppEnv == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	r := gin.New()
	r.Use(middleware.Recovery())
	r.Use(middleware.Logger())
	r.Use(middleware.CORS())
	r.Use(middleware.RateLimit())

	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	api := r.Group("/api/v1")
	auth.Bootstrap(api, database.DB)

	log.Printf("Server running on port %s", config.App.AppPort)
	if err := r.Run(":" + config.App.AppPort); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
