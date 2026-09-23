# API Requirements — Frontend User Side

> **Legend:** ✅ Done (backend ready) | ⬜ Pending (API banvaychi aahe)

---

## 1. Auth Screens

| Screen | API | Method | Status | Notes |
|--------|-----|--------|--------|-------|
| Login Page | `POST /auth/login` | POST | ✅ | Returns `access_token`, `refresh_token`, `user` |
| Register Page | `POST /auth/register` | POST | ✅ | Body: `full_name`, `email`, `password` |
| Forgot Password Page | `POST /auth/forgot-password` | POST | ✅ | OTP generate होतो + email var pathavto |
| Reset Password Page | `POST /auth/reset-password` | POST | ✅ | Body: `email`, `otp`, `new_password` |
| Logout | `POST /auth/logout` | POST | ✅ | |
| Token Refresh | `POST /auth/refresh-token` | POST | ✅ | Body: `refresh_token` |

> **OTP Flow (Forgot → Reset):**
> 1. User email takto → `POST /auth/forgot-password` → 6-digit OTP email var jato (10 min valid)
> 2. User OTP takto → `POST /auth/reset-password` → `{ email, otp, new_password }` pathavto

---

## 2. Dashboard Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Load user's resumes list | `GET /resumes` | GET | ✅ |
| Usage / quota info | `GET /profile` | GET | ✅ |

---

## 3. My Resumes Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| List all resumes | `GET /resumes` | GET | ✅ |
| Create new resume | `POST /resumes` | POST | ✅ |
| Delete resume | `DELETE /resumes/:id` | DELETE | ✅ |
| Duplicate resume | `POST /resumes/:id/duplicate` | POST | ✅ |
| Rename resume | `PUT /resumes/:id` | PUT | ✅ |

---

## 4. Resume Builder Screen (Sections)

| Screen / Section | API | Method | Status |
|-----------------|-----|--------|--------|
| Personal Information | `PUT /resumes/:id` (personalInfo field) | PUT | ✅ |
| Summary | `PUT /resumes/:id` (summary field) | PUT | ✅ |
| Education | `GET/POST /resumes/:id/education` | GET, POST | ✅ |
| Education (edit/delete) | `PUT/DELETE /resumes/:id/education/:eid` | PUT, DELETE | ✅ |
| Experience | `GET/POST /resumes/:id/experience` | GET, POST | ✅ |
| Experience (edit/delete) | `PUT/DELETE /resumes/:id/experience/:eid` | PUT, DELETE | ✅ |
| Skills | `GET/POST /resumes/:id/skills` | GET, POST | ✅ |
| Skills (edit/delete) | `PUT/DELETE /resumes/:id/skills/:sid` | PUT, DELETE | ✅ |
| Projects | `GET/POST /resumes/:id/projects` | GET, POST | ✅ |
| Projects (edit/delete) | `PUT/DELETE /resumes/:id/projects/:pid` | PUT, DELETE | ✅ |
| Certifications | `GET/POST /resumes/:id/certifications` | GET, POST | ✅ |
| Certifications (edit/delete) | `PUT/DELETE /resumes/:id/certifications/:cid` | PUT, DELETE | ✅ |
| Achievements | `GET/POST /resumes/:id/achievements` | GET, POST | ✅ |
| Achievements (edit/delete) | `PUT/DELETE /resumes/:id/achievements/:aid` | PUT, DELETE | ✅ |
| Languages | `GET/POST /resumes/:id/languages` | GET, POST | ✅ |
| Languages (edit/delete) | `PUT/DELETE /resumes/:id/languages/:lid` | PUT, DELETE | ✅ |

---

## 5. Template Selection Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| List all templates | `GET /templates` | GET | ⬜ |
| Get template by ID | `GET /templates/:id` | GET | ⬜ |

> **Note:** Currently templates are hardcoded locally in Flutter (`_localTemplates`). Backend API banvaychi aahe.

---

## 6. Resume Preview Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Get resume by ID (for preview) | `GET /resumes/:id` | GET | ✅ |

---

## 7. PDF Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Generate & download PDF | `GET /resumes/:id/pdf` | GET | ⬜ |

> **Note:** PDF generation API banvaychi aahe. Response binary bytes (PDF file) asel.

---

## 8. ATS Analysis Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Run ATS analysis | `POST /resumes/:id/ats-analysis` | POST | ⬜ |
| Get existing ATS result | `GET /resumes/:id/ats-analysis` | GET | ⬜ |

> **Note:** ATS scoring logic + API banvaychi aahe.

---

## 9. Profile Screen

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Get profile | `GET /profile` | GET | ⬜ |
| Update profile | `PUT /profile` | PUT | ⬜ |
| Get subscription info | `GET /profile` (subscription field) | GET | ⬜ |

---

## 10. AI Tools Screens

| Screen | Feature | API | Method | Status |
|--------|---------|-----|--------|--------|
| Cover Letter Generator | Generate cover letter using resume data | `POST /tools/cover-letter` | POST | ⬜ |
| JD Matcher | Match resume vs job description | `POST /tools/jd-match` | POST | ⬜ |
| Interview Prep | Generate interview Q&A from resume | `POST /tools/interview-prep` | POST | ⬜ |
| Salary Estimator | Estimate salary (local calculation) | — (no API needed, client-side) | — | ✅ |

> **Note:** Cover Letter, JD Matcher, Interview Prep — teeno currently **mock/hardcoded data** vaparatat. Real AI API banvaychi aahe (OpenAI / Gemini integration).

---

## 11. Subscription / Quota

| Feature | API | Method | Status |
|---------|-----|--------|--------|
| Check & consume AI quota | `POST /subscription/consume` or part of `/profile` | POST | ⬜ |
| Get current plan & limits | `GET /profile` (subscription field) | GET | ⬜ |

---

## Summary

| Category | Total APIs | Done ✅ | Pending ⬜ |
|----------|-----------|---------|-----------|
| Auth | 6 | 6 | 0 |
| Resume CRUD | 5 | 5 | 0 |
| Resume Sections | 16 | 16 | 0 |
| Templates | 2 | 0 | 2 |
| PDF | 1 | 0 | 1 |
| ATS Analysis | 2 | 0 | 2 |
| Profile | 3 | 0 | 3 |
| AI Tools | 3 | 0 | 3 |
| Subscription/Quota | 2 | 0 | 2 |
| **Total** | **40** | **27** | **13** |
