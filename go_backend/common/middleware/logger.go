package middleware

import (
	"time"

	"github.com/gin-gonic/gin"
)

func Logger() gin.HandlerFunc {
	return gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
		return param.TimeStamp.Format(time.RFC3339) + " | " +
			param.Method + " " + param.Path + " | " +
			param.ClientIP + " | " +
			string(rune('0'+param.StatusCode/100)) + "xx | " +
			param.Latency.String() + "\n"
	})
}
