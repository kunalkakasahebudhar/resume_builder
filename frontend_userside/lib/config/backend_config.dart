class BackendConfig {
  // ── Base URL ──────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://localhost:8080/api/v1';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const String profile = '/profile';

  // ── Resumes ───────────────────────────────────────────────────────────────
  static const String resumes = '/resumes';
  static String resumeById(String id) => '/resumes/$id';
  static String duplicateResume(String id) => '/resumes/$id/duplicate';

  // ── Resume Sections (scoped under a resume) ───────────────────────────────
  static String education(String resumeId) => '/resumes/$resumeId/education';
  static String educationById(String resumeId, String id) => '/resumes/$resumeId/education/$id';

  static String skills(String resumeId) => '/resumes/$resumeId/skills';
  static String skillById(String resumeId, String id) => '/resumes/$resumeId/skills/$id';

  static String experience(String resumeId) => '/resumes/$resumeId/experience';
  static String experienceById(String resumeId, String id) => '/resumes/$resumeId/experience/$id';

  static String projects(String resumeId) => '/resumes/$resumeId/projects';
  static String projectById(String resumeId, String id) => '/resumes/$resumeId/projects/$id';

  static String certifications(String resumeId) => '/resumes/$resumeId/certifications';
  static String certificationById(String resumeId, String id) => '/resumes/$resumeId/certifications/$id';

  static String achievements(String resumeId) => '/resumes/$resumeId/achievements';
  static String achievementById(String resumeId, String id) => '/resumes/$resumeId/achievements/$id';

  static String languages(String resumeId) => '/resumes/$resumeId/languages';
  static String languageById(String resumeId, String id) => '/resumes/$resumeId/languages/$id';

  // ── Templates ─────────────────────────────────────────────────────────────
  static const String templates = '/templates';
  static String templateById(String id) => '/templates/$id';

  // ── ATS Analysis ──────────────────────────────────────────────────────────
  static String atsAnalysis(String resumeId) => '/resumes/$resumeId/ats-analysis';

  // ── PDF ───────────────────────────────────────────────────────────────────
  static String pdf(String resumeId) => '/resumes/$resumeId/pdf';
}
