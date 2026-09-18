class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api/admin';

  // Auth
  static const String login = '/login';
  static const String logout = '/logout';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Users
  static const String users = '/users';
  static String userDetails(String id) => '/users/$id';
  static String userStatus(String id) => '/users/$id/status';

  // Resumes
  static const String resumes = '/resumes';
  static String resumeDetails(String id) => '/resumes/$id';

  // Templates
  static const String templates = '/templates';
  static String templateDetails(String id) => '/templates/$id';
  static String templateStatus(String id) => '/templates/$id/status';

  // Analytics
  static const String analytics = '/analytics';

  // Profile
  static const String profile = '/profile';
}
