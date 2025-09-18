import 'app_config.dart';

class ApiConfig {
  static const String baseUrl = AppConfig.baseUrl;
  static const String apiPrefix = '/api/flutter';
  
  // Base API URL
  static String get apiBaseUrl => '$baseUrl$apiPrefix';
  
  // Authentication Endpoints
  static String get registerUrl => '$apiBaseUrl/register';
  static String get loginUrl => '$apiBaseUrl/login';
  
  // Profile Endpoints
  static String get profileUrl => '$apiBaseUrl/profile';
  
  // Report Endpoints
  static String get reportsUrl => '$apiBaseUrl/reports';
  static String get myReportsUrl => '$apiBaseUrl/my-reports';
  static String reportDetailUrl(String id) => '$reportsUrl/$id';
  
  // Socket.IO
  static String get socketUrl => AppConfig.socketUrl;
  
  // Request Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}