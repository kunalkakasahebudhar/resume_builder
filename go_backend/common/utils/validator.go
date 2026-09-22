package utils

import (
	"regexp"
	"strings"
)

func IsValidEmail(email string) bool {
	re := regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)
	return re.MatchString(strings.TrimSpace(email))
}

func IsValidPassword(password string) bool {
	return len(password) >= 8
}
