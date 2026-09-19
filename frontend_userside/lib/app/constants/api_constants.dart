class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';

  // Profile
  static const String profile = '/profile';

  // Resumes
  static const String resumes = '/resumes';
  static String resumeById(String id) => '/resumes/$id';

  // Resume Sections
  static const String education = '/education';
  static const String skills = '/skills';
  static const String experience = '/experience';
  static const String projects = '/projects';
  static const String certifications = '/certifications';
  static const String achievements = '/achievements';
  static const String languages = '/languages';

  // Templates
  static const String templates = '/templates';

  // ATS Analysis
  static String atsAnalysis(String resumeId) =>
      '/resumes/$resumeId/ats-analysis';

  // PDF
  static String pdf(String resumeId) => '/resumes/$resumeId/pdf';
}
