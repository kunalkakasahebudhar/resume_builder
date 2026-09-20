package middleware

import (
	"net/http"
	"resume_builder/common/utils"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type visitor struct {
	count    int
	lastSeen time.Time
}

var (
	visitors = make(map[string]*visitor)
	mu       sync.Mutex
	limit    = 100
	window   = time.Minute
)

func RateLimit() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()
		mu.Lock()
		v, exists := visitors[ip]
		if !exists || time.Since(v.lastSeen) > window {
			visitors[ip] = &visitor{count: 1, lastSeen: time.Now()}
			mu.Unlock()
			c.Next()
			return
		}
		v.count++
		v.lastSeen = time.Now()
		if v.count > limit {
			mu.Unlock()
			utils.SendError(c, http.StatusTooManyRequests, "too many requests")
			c.Abort()
			return
		}
		mu.Unlock()
		c.Next()
	}
}
