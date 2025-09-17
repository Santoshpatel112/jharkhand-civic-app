import 'package:flutter/material.dart';
import '../models/citizen.dart';
import '../models/api_response.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';

class AuthProvider extends ChangeNotifier {
  Citizen? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  Citizen? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isInitialized => _isInitialized;

  // Initialize auth state
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    
    try {
      if (AuthService.isLoggedIn()) {
        final user = AuthService.getCurrentUser();
        if (user != null) {
          _currentUser = user;
          
          // Initialize socket connection for authenticated user
          SocketService.initialize();
          
          // Try to refresh user profile from server
          await _refreshProfile();
        }
      }
    } catch (e) {
      _setError('Failed to initialize auth: ${e.toString()}');
    } finally {
      _isInitialized = true;
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    Map<String, dynamic>? location,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AuthService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        location: location,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );

      if (response.success && response.data != null) {
        _currentUser = Citizen.fromJson(response.data!.citizen);
        
        // Initialize socket connection
        SocketService.initialize();
        
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        _currentUser = Citizen.fromJson(response.data!.citizen);
        
        // Initialize socket connection
        SocketService.initialize();
        
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // Disconnect socket
      SocketService.disconnect();
      
      // Clear auth data
      await AuthService.logout();
      
      _currentUser = null;
      _clearError();
      
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    Map<String, dynamic>? location,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AuthService.updateProfile(
        name: name,
        phone: phone,
        location: location,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );

      if (response.success && response.data != null) {
        _currentUser = response.data;
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Profile update failed');
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user profile from server
  Future<void> refreshProfile() async {
    await _refreshProfile();
  }

  // Private method to refresh profile
  Future<void> _refreshProfile() async {
    try {
      final response = await AuthService.getProfile();
      
      if (response.success && response.data != null) {
        _currentUser = response.data;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail for profile refresh
      print('Failed to refresh profile: $e');
    }
  }

  // Check authentication status
  Future<bool> checkAuthStatus() async {
    if (!AuthService.isLoggedIn()) {
      return false;
    }

    try {
      final response = await AuthService.getProfile();
      
      if (response.success && response.data != null) {
        _currentUser = response.data;
        notifyListeners();
        return true;
      } else {
        // Token might be invalid, logout
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Update specific user fields
  void updateUserField(String field, dynamic value) {
    if (_currentUser == null) return;

    switch (field) {
      case 'totalReports':
        _currentUser = _currentUser!.copyWith(totalReports: value);
        break;
      case 'resolvedReports':
        _currentUser = _currentUser!.copyWith(resolvedReports: value);
        break;
      case 'rating':
        _currentUser = _currentUser!.copyWith(rating: value.toDouble());
        break;
    }
    
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Get user initials for avatar
  String getUserInitials() {
    if (_currentUser?.name == null) return 'U';
    
    final nameParts = _currentUser!.name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return _currentUser!.name.substring(0, 1).toUpperCase();
    }
  }

  // Get user display name
  String getUserDisplayName() {
    return _currentUser?.name ?? 'User';
  }

  // Get user stats
  Map<String, int> getUserStats() {
    if (_currentUser == null) {
      return {
        'total': 0,
        'resolved': 0,
        'pending': 0,
      };
    }

    return {
      'total': _currentUser!.totalReports,
      'resolved': _currentUser!.resolvedReports,
      'pending': _currentUser!.totalReports - _currentUser!.resolvedReports,
    };
  }
}