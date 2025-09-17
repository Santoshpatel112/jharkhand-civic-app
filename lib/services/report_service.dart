import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/report.dart';
import 'auth_service.dart';

class ReportService {
  // Submit a new report
  static Future<ApiResponse<Report>> submitReport({
    required String title,
    required String description,
    required String category,
    required String priority,
    required Map<String, dynamic> location,
    List<String>? images,
    List<String>? tags,
  }) async {
    try {
      final token = AuthService.getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final response = await http.post(
        Uri.parse(ApiConfig.reportsUrl),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': category,
          'priority': priority,
          'location': location,
          'images': images ?? [],
          'tags': tags ?? [],
        }),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        final report = Report.fromJson(responseData['data']);
        return ApiResponse.success(
          data: report,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to submit report',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get citizen's reports
  static Future<ApiResponse<List<Report>>> getMyReports({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final token = AuthService.getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(ApiConfig.myReportsUrl).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final reportsData = responseData['data'] as List;
        final reports = reportsData.map((json) => Report.fromJson(json)).toList();
        
        return ApiResponse<List<Report>>(
          success: true,
          data: reports,
          message: responseData['message'],
          pagination: responseData['pagination'] != null 
            ? Pagination.fromJson(responseData['pagination'])
            : null,
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to get reports',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get specific report details
  static Future<ApiResponse<Report>> getReportDetails(String reportId) async {
    try {
      final token = AuthService.getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final response = await http.get(
        Uri.parse(ApiConfig.reportDetailUrl(reportId)),
        headers: ApiConfig.authHeaders(token),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final report = Report.fromJson(responseData['data']);
        return ApiResponse.success(
          data: report,
          message: responseData['message'],
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to get report details',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get reports with filters (for dashboard/analytics)
  static Future<ApiResponse<List<Report>>> getReportsWithFilters({
    int page = 1,
    int limit = 10,
    String? status,
    String? priority,
    String? category,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final token = AuthService.getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (priority != null && priority.isNotEmpty) queryParams['priority'] = priority;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (sortBy != null && sortBy.isNotEmpty) queryParams['sortBy'] = sortBy;
      if (sortOrder != null && sortOrder.isNotEmpty) queryParams['sortOrder'] = sortOrder;

      final uri = Uri.parse(ApiConfig.reportsUrl).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(AppConfig.apiTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final reportsData = responseData['data'] as List;
        final reports = reportsData.map((json) => Report.fromJson(json)).toList();
        
        return ApiResponse<List<Report>>(
          success: true,
          data: reports,
          message: responseData['message'],
          pagination: responseData['pagination'] != null 
            ? Pagination.fromJson(responseData['pagination'])
            : null,
        );
      } else {
        return ApiResponse.error(
          error: responseData['message'] ?? 'Failed to get reports',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get report statistics for citizen dashboard
  static Future<ApiResponse<Map<String, dynamic>>> getReportStats() async {
    try {
      final token = AuthService.getToken();
      if (token == null) {
        return ApiResponse.error(error: 'No authentication token found');
      }

      // This would call a stats endpoint - for now we'll simulate it
      final myReportsResponse = await getMyReports(limit: 1000); // Get all reports
      
      if (myReportsResponse.success && myReportsResponse.data != null) {
        final reports = myReportsResponse.data!;
        
        final stats = {
          'total': reports.length,
          'submitted': reports.where((r) => r.status == 'submitted').length,
          'progress': reports.where((r) => r.status == 'progress').length,
          'resolved': reports.where((r) => r.status == 'resolved').length,
          'high_priority': reports.where((r) => r.priority == 'high').length,
          'medium_priority': reports.where((r) => r.priority == 'medium').length,
          'low_priority': reports.where((r) => r.priority == 'low').length,
        };
        
        return ApiResponse.success(data: stats);
      } else {
        return ApiResponse.error(error: 'Failed to calculate statistics');
      }
    } catch (e) {
      return ApiResponse.error(
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // Helper method to get status color
  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return '#FFC107'; // Amber
      case 'progress':
        return '#2196F3'; // Blue
      case 'resolved':
        return '#4CAF50'; // Green
      default:
        return '#757575'; // Grey
    }
  }

  // Helper method to get priority color
  static String getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return '#F44336'; // Red
      case 'medium':
        return '#FF9800'; // Orange
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#757575'; // Grey
    }
  }

  // Validate report data before submission
  static String? validateReportData({
    required String title,
    required String description,
    required String category,
    required String priority,
    required Map<String, dynamic> location,
  }) {
    if (title.trim().isEmpty) {
      return 'Title is required';
    }
    
    if (title.length < 5) {
      return 'Title must be at least 5 characters long';
    }
    
    if (description.trim().isEmpty) {
      return 'Description is required';
    }
    
    if (description.length < 10) {
      return 'Description must be at least 10 characters long';
    }
    
    if (!AppConfig.reportCategories.map((c) => c.toLowerCase()).contains(category.toLowerCase())) {
      return 'Invalid category selected';
    }
    
    if (!AppConfig.priorityLevels.map((p) => p.toLowerCase()).contains(priority.toLowerCase())) {
      return 'Invalid priority selected';
    }
    
    if (location['latitude'] == null || location['longitude'] == null) {
      return 'Location is required';
    }
    
    return null; // No validation errors
  }
}