package auth

import (
	"fmt"
	"net/smtp"
	"resume_builder/common/config"
)

type EmailService interface {
	SendOTP(toEmail, otp string) error
}

type smtpEmailService struct{}

func NewEmailService() EmailService {
	return &smtpEmailService{}
}

func (s *smtpEmailService) SendOTP(toEmail, otp string) error {
	cfg := config.App
	addr := fmt.Sprintf("%s:%d", cfg.SMTPHost, cfg.SMTPPort)
	auth := smtp.PlainAuth("", cfg.SMTPUser, cfg.SMTPPassword, cfg.SMTPHost)

	subject := "Subject: Your Password Reset OTP\r\n"
	mime := "MIME-version: 1.0;\r\nContent-Type: text/html; charset=\"UTF-8\";\r\n"
	body := fmt.Sprintf(`
<p>Your OTP for password reset is:</p>
<h2>%s</h2>
<p>This OTP is valid for %d minutes. Do not share it with anyone.</p>
`, otp, cfg.OTPExpiryMinutes)

	msg := []byte("From: " + cfg.SMTPFrom + "\r\n" +
		"To: " + toEmail + "\r\n" +
		subject + mime + "\r\n" + body)

	return smtp.SendMail(addr, auth, cfg.SMTPFrom, []string{toEmail}, msg)
}
