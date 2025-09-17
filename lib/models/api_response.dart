class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final Pagination? pagination;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null 
        ? fromJsonT(json['data']) 
        : json['data'],
      message: json['message'],
      error: json['error'],
      pagination: json['pagination'] != null 
        ? Pagination.fromJson(json['pagination']) 
        : null,
    );
  }

  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error({String? error, String? message}) {
    return ApiResponse<T>(
      success: false,
      error: error ?? message,
      message: message,
    );
  }
}

class Pagination {
  final int current;
  final int total;
  final int count;
  final int totalRecords;

  Pagination({
    required this.current,
    required this.total,
    required this.count,
    required this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json['current'] ?? 1,
      total: json['total'] ?? 1,
      count: json['count'] ?? 0,
      totalRecords: json['totalRecords'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'total': total,
      'count': count,
      'totalRecords': totalRecords,
    };
  }

  bool get hasNextPage => current < total;
  bool get hasPreviousPage => current > 1;
}

class AuthResponse {
  final String token;
  final dynamic citizen;

  AuthResponse({
    required this.token,
    required this.citizen,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      citizen: json['citizen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'citizen': citizen,
    };
  }
}