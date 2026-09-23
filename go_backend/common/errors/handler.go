package errors

import (
	"errors"
	"net/http"
	"resume_builder/common/utils"

	"github.com/gin-gonic/gin"
)

func Handle(c *gin.Context, err error) {
	switch {
	case errors.Is(err, ErrNotFound):
		utils.SendError(c, http.StatusNotFound, err.Error())
	case errors.Is(err, ErrUnauthorized), errors.Is(err, ErrTokenInvalid):
		utils.SendError(c, http.StatusUnauthorized, err.Error())
	case errors.Is(err, ErrForbidden):
		utils.SendError(c, http.StatusForbidden, err.Error())
	case errors.Is(err, ErrBadRequest), errors.Is(err, ErrEmailExists),
		errors.Is(err, ErrOTPInvalid), errors.Is(err, ErrAccountNotVerified):
		utils.SendError(c, http.StatusBadRequest, err.Error())
	case errors.Is(err, ErrInvalidCredentials):
		utils.SendError(c, http.StatusUnauthorized, err.Error())
	default:
		utils.SendError(c, http.StatusInternalServerError, ErrInternalServer.Error())
	}
}
