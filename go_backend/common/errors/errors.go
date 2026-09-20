package errors

import "errors"

var (
	ErrNotFound           = errors.New("record not found")
	ErrUnauthorized       = errors.New("unauthorized")
	ErrForbidden          = errors.New("forbidden")
	ErrBadRequest         = errors.New("bad request")
	ErrInternalServer     = errors.New("internal server error")
	ErrEmailExists        = errors.New("email already exists")
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrAccountNotVerified = errors.New("account not verified")
	ErrOTPInvalid         = errors.New("invalid or expired otp")
	ErrTokenInvalid       = errors.New("invalid or expired token")
)
