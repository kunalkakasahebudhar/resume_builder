package auth

import (
	"fmt"
	"net/smtp"
	"resume_builder/common/config"
	"strconv"
)

type emailService struct{}

func NewEmailService() EmailService {
	return &emailService{}
}

func (e *emailService) SendOTP(toEmail, name, otp, otpType string) error {
	cfg := config.App
	subject, body := buildEmail(name, otp, otpType)

	msg := fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n%s",
		cfg.SMTPFrom, toEmail, subject, body)

	auth := smtp.PlainAuth("", cfg.SMTPUser, cfg.SMTPPassword, cfg.SMTPHost)
	addr := cfg.SMTPHost + ":" + strconv.Itoa(cfg.SMTPPort)
	return smtp.SendMail(addr, auth, cfg.SMTPFrom, []string{toEmail}, []byte(msg))
}

func buildEmail(name, otp, otpType string) (subject, body string) {
	switch otpType {
	case "password_reset":
		subject = "Password Reset OTP"
		body = fmt.Sprintf("<h2>Hi %s,</h2><p>Your password reset OTP is: <strong>%s</strong></p><p>Valid for 10 minutes.</p>", name, otp)
	default:
		subject = "Email Verification OTP"
		body = fmt.Sprintf("<h2>Hi %s,</h2><p>Your email verification OTP is: <strong>%s</strong></p><p>Valid for 10 minutes.</p>", name, otp)
	}
	return
}
