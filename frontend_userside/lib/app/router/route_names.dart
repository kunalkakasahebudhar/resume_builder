class RouteNames {
  // Public
  static const String landing = '/';
  static const String landingAlt = '/landing';

  // Public Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Protected Core
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String resumes = '/resumes';
  static const String createResume = '/resumes/new';
  static const String resumeBuilder = '/resumes/:id';

  // Resume Sections
  static const String personalInformation = '/resumes/:id/personal-information';
  static const String summary = '/resumes/:id/summary';
  static const String education = '/resumes/:id/education';
  static const String skills = '/resumes/:id/skills';
  static const String experience = '/resumes/:id/experience';
  static const String projects = '/resumes/:id/projects';
  static const String certifications = '/resumes/:id/certifications';
  static const String achievements = '/resumes/:id/achievements';
  static const String languages = '/resumes/:id/languages';

  // Features & AI Tools
  static const String templates = '/templates';
  static const String preview = '/preview';
  static const String ats = '/ats';
  static const String pdf = '/pdf';
  static const String jdMatcher = '/jd-matcher';
  static const String coverLetter = '/cover-letter';
  static const String interviewPrep = '/interview-prep';
  static const String salaryEstimator = '/salary-estimator';
}
