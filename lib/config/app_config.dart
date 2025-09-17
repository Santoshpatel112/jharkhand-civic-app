class AppConfig {
  static const String appName = 'Jharkhand Civic Reporter';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://192.168.1.100:5000'; // Change to your backend URL
  static const String socketUrl = 'http://192.168.1.100:5000';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // App Constraints
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImagesPerReport = 5;
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Location Settings
  static const double defaultLatitude = 23.3569;
  static const double defaultLongitude = 85.3350;
  static const String defaultAddress = 'Ranchi, Jharkhand';
  
  // Report Categories
  static const List<String> reportCategories = [
    'Infrastructure',
    'Sanitation',
    'Public Safety',
    'Transportation',
    'Water Supply',
    'Electricity',
    'Healthcare',
    'Education',
    'Environment',
    'Other'
  ];
  
  // Priority Levels
  static const List<String> priorityLevels = [
    'Low',
    'Medium',
    'High'
  ];
}