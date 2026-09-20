package auth

import (
	apperrors "resume_builder/common/errors"
	"resume_builder/common/constants"
	"resume_builder/common/utils"
	"resume_builder/internal/auth/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	svc Service
}

func NewHandler(svc Service) *Handler {
	return &Handler{svc: svc}
}

func (h *Handler) Register(c *gin.Context) {
	var req models.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	if err := h.svc.Register(&req); err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusCreated, constants.MsgRegistered, nil)
}

func (h *Handler) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	resp, err := h.svc.Login(&req)
	if err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusOK, constants.MsgLoggedIn, resp)
}

func (h *Handler) VerifyEmail(c *gin.Context) {
	var req models.VerifyEmailRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	if err := h.svc.VerifyEmail(&req); err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusOK, constants.MsgOTPVerified, nil)
}

func (h *Handler) ForgotPassword(c *gin.Context) {
	var req models.ForgotPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	if err := h.svc.ForgotPassword(&req); err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusOK, constants.MsgOTPSent, nil)
}

func (h *Handler) ResetPassword(c *gin.Context) {
	var req models.ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	if err := h.svc.ResetPassword(&req); err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusOK, constants.MsgPasswordReset, nil)
}

func (h *Handler) RefreshToken(c *gin.Context) {
	var req models.RefreshTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.SendError(c, http.StatusBadRequest, err.Error())
		return
	}
	resp, err := h.svc.RefreshToken(&req)
	if err != nil {
		apperrors.Handle(c, err)
		return
	}
	utils.SendSuccess(c, http.StatusOK, constants.MsgSuccess, resp)
}
