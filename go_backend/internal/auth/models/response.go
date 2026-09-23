package models

type AuthResponse struct {
	AccessToken  string   `json:"access_token"`
	RefreshToken string   `json:"refresh_token"`
	User         UserInfo `json:"user"`
}

type UserInfo struct {
	ID         uint   `json:"id"`
	FullName   string `json:"full_name"`
	Email      string `json:"email"`
	IsVerified bool   `json:"is_verified"`
	Status     string `json:"status"`
}
