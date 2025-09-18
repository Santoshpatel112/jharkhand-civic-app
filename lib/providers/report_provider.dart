import 'package:flutter/material.dart';
import '../models/report.dart';
import '../models/api_response.dart';
import '../services/report_service.dart';
import '../services/socket_service.dart';

class ReportProvider extends ChangeNotifier {
  List<Report> _reports = [];
  Report? _selectedReport;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  Map<String, dynamic> _stats = {};
  Pagination? _pagination;

  // Getters
  List<Report> get reports => _reports;
  Report? get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  Map<String, dynamic> get stats => _stats;
  Pagination? get pagination => _pagination;

  // Initialize provider
  void initialize() {
    _setupSocketListeners();
  }

  // Setup Socket.IO listeners for real-time updates
  void _setupSocketListeners() {
    SocketService.setOnReportUpdate((data) {
      _handleReportUpdate(data);
    });

    SocketService.setOnReportAssigned((data) {
      _handleReportAssigned(data);
    });

    SocketService.setOnReportResolved((data) {
      _handleReportResolved(data);
    });
  }

  // Submit a new report
  Future<bool> submitReport({
    required String title,
    required String description,
    required String category,
    required String priority,
    required Map<String, dynamic> location,
    List<String>? images,
    List<String>? tags,
  }) async {
    // Validate report data
    final validationError = ReportService.validateReportData(
      title: title,
      description: description,
      category: category,
      priority: priority,
      location: location,
    );

    if (validationError != null) {
      _setError(validationError);
      return false;
    }

    _setSubmitting(true);
    _clearError();

    try {
      final response = await ReportService.submitReport(
        title: title,
        description: description,
        category: category,
        priority: priority,
        location: location,
        images: images,
        tags: tags,
      );

      if (response.success && response.data != null) {
        // Add new report to the beginning of the list
        _reports.insert(0, response.data!);
        
        // Update stats
        await _refreshStats();
        
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Failed to submit report');
        return false;
      }
    } catch (e) {
      _setError('Failed to submit report: ${e.toString()}');
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  // Load citizen's reports
  Future<void> loadMyReports({
    int page = 1,
    int limit = 10,
    String? status,
    bool append = false,
  }) async {
    if (!append) {
      _setLoading(true);
    }
    _clearError();

    try {
      final response = await ReportService.getMyReports(
        page: page,
        limit: limit,
        status: status,
      );

      if (response.success && response.data != null) {
        if (append) {
          _reports.addAll(response.data!);
        } else {
          _reports = response.data!;
        }
        
        _pagination = response.pagination;
        
        // Load stats if this is the first page
        if (page == 1) {
          await _refreshStats();
        }
        
        notifyListeners();
      } else {
        _setError(response.error ?? 'Failed to load reports');
      }
    } catch (e) {
      _setError('Failed to load reports: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load more reports (pagination)
  Future<void> loadMoreReports({String? status}) async {
    if (_pagination == null || !_pagination!.hasNextPage) return;

    await loadMyReports(
      page: _pagination!.current + 1,
      status: status,
      append: true,
    );
  }

  // Load specific report details
  Future<void> loadReportDetails(String reportId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ReportService.getReportDetails(reportId);

      if (response.success && response.data != null) {
        _selectedReport = response.data!;
        
        // Update the report in the list if it exists
        final index = _reports.indexWhere((r) => r.id == reportId);
        if (index != -1) {
          _reports[index] = response.data!;
        }
        
        notifyListeners();
      } else {
        _setError(response.error ?? 'Failed to load report details');
      }
    } catch (e) {
      _setError('Failed to load report details: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh reports
  Future<void> refreshReports({String? status}) async {
    await loadMyReports(status: status);
  }

  // Filter reports by status
  List<Report> getReportsByStatus(String status) {
    return _reports.where((report) => report.status == status).toList();
  }

  // Get reports by priority
  List<Report> getReportsByPriority(String priority) {
    return _reports.where((report) => report.priority == priority).toList();
  }

  // Get reports by category
  List<Report> getReportsByCategory(String category) {
    return _reports.where((report) => report.category == category).toList();
  }

  // Search reports
  List<Report> searchReports(String query) {
    if (query.isEmpty) return _reports;
    
    final lowerQuery = query.toLowerCase();
    return _reports.where((report) =>
      report.title.toLowerCase().contains(lowerQuery) ||
      report.description.toLowerCase().contains(lowerQuery) ||
      report.location.address.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Handle real-time report updates
  void _handleReportUpdate(Map<String, dynamic> data) {
    try {
      final updatedReport = Report.fromJson(data['data'] ?? data);
      final index = _reports.indexWhere((r) => r.id == updatedReport.id);
      
      if (index != -1) {
        _reports[index] = updatedReport;
        
        // Update selected report if it's the same
        if (_selectedReport?.id == updatedReport.id) {
          _selectedReport = updatedReport;
        }
        
        notifyListeners();
      }
    } catch (e) {
      print('Error handling report update: $e');
    }
  }

  // Handle real-time report assignment
  void _handleReportAssigned(Map<String, dynamic> data) {
    _handleReportUpdate(data); // Same logic as update
  }

  // Handle real-time report resolution
  void _handleReportResolved(Map<String, dynamic> data) {
    _handleReportUpdate(data); // Same logic as update
  }

  // Refresh stats
  Future<void> _refreshStats() async {
    try {
      final response = await ReportService.getReportStats();
      if (response.success && response.data != null) {
        _stats = response.data!;
      }
    } catch (e) {
      print('Failed to refresh stats: $e');
    }
  }

  // Clear selected report
  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }

  // Clear all reports
  void clearReports() {
    _reports.clear();
    _selectedReport = null;
    _pagination = null;
    _stats.clear();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSubmitting(bool submitting) {
    _isSubmitting = submitting;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Get report counts by status
  Map<String, int> getReportCounts() {
    final counts = <String, int>{
      'total': _reports.length,
      'submitted': 0,
      'progress': 0,
      'resolved': 0,
    };

    for (final report in _reports) {
      counts[report.status] = (counts[report.status] ?? 0) + 1;
    }

    return counts;
  }

  // Get report counts by priority
  Map<String, int> getPriorityCounts() {
    final counts = <String, int>{
      'high': 0,
      'medium': 0,
      'low': 0,
    };

    for (final report in _reports) {
      counts[report.priority] = (counts[report.priority] ?? 0) + 1;
    }

    return counts;
  }

  // Get recent reports (last 7 days)
  List<Report> getRecentReports() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _reports.where((report) => report.createdAt.isAfter(weekAgo)).toList();
  }

  // Check if there are any high priority pending reports
  bool hasHighPriorityPending() {
    return _reports.any((report) => 
      report.priority == 'high' && 
      (report.status == 'submitted' || report.status == 'progress')
    );
  }

  @override
  void dispose() {
    SocketService.clearCallbacks();
    super.dispose();
  }
}