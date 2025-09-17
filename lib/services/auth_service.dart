import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/citizen.dart';
import 'storage_service.dart';

class AuthService {
  static const String _tokenKey = AppConfig.authTokenKey;
  static const String _userDataKey = AppConfig.userDataKey;

  // Register new citizen
  static Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    Map<String, dynamic>? location,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'location': location,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
          'gender': gender,
        }),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        final authResponse = AuthResponse.fromJson(responseData['data']);
        
        // Store token and user data
        await _storeAuthData(authResponse);
        
        return ApiResponse.success(
          data: authResponse,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Login citizen
  static Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final authResponse = AuthResponse.fromJson(responseData['data']);
        
        // Store token and user data
        await _storeAuthData(authResponse);
        
        return ApiResponse.success(
          data: authResponse,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get current user profile
  static Future<ApiResponse<Citizen>> getProfile() async {
    try {
      final token = getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: ApiConfig.authHeaders(token),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final citizen = Citizen.fromJson(responseData['data']['citizen']);
        
        // Update stored user data
        await StorageService.setJson(_userDataKey, citizen.toJson());
        
        return ApiResponse.success(
          data: citizen,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to get profile',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Update user profile
  static Future<ApiResponse<Citizen>> updateProfile({
    String? name,
    String? phone,
    Map<String, dynamic>? location,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    try {
      final token = getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (location != null) updateData['location'] = location;
      if (dateOfBirth != null) updateData['dateOfBirth'] = dateOfBirth.toIso8601String();
      if (gender != null) updateData['gender'] = gender;

      final response = await http.put(
        Uri.parse(ApiConfig.profileUrl),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(updateData),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final citizen = Citizen.fromJson(responseData['data']);
        
        // Update stored user data
        await StorageService.setJson(_userDataKey, citizen.toJson());
        
        return ApiResponse.success(
          data: citizen,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to update profile',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Logout
  static Future<void> logout() async {
    await StorageService.remove(_tokenKey);
    await StorageService.remove(_userDataKey);
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Get stored token
  static String? getToken() {
    return StorageService.getString(_tokenKey);
  }

  // Get stored user data
  static Citizen? getCurrentUser() {
    final userData = StorageService.getJson(_userDataKey);
    if (userData != null) {
      try {
        return Citizen.fromJson(userData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Store authentication data
  static Future<void> _storeAuthData(AuthResponse authResponse) async {
    await StorageService.setString(_tokenKey, authResponse.token);
    await StorageService.setJson(_userDataKey, authResponse.citizen);
  }

  // Validate token format (basic validation)
  static bool isValidToken(String? token) {
    if (token == null || token.isEmpty) return false;
    
    // Basic JWT token format validation (3 parts separated by dots)
    final parts = token.split('.');
    return parts.length == 3;
  }

  // Auto-refresh token if needed (placeholder for future implementation)
  static Future<bool> refreshTokenIfNeeded() async {
    // This would implement token refresh logic
    // For now, just check if token exists
    return isLoggedIn();
  }
}