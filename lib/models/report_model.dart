class ReportModel {
  final String id;
  final String userId;
  final String? categoryId;
  final String title;
  final String description;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String priority;
  final String status;
  final List<String> images;
  final List<String> audioFiles;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReportCategory? category;
  final UserProfile? userProfile;

  ReportModel({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    required this.description,
    this.locationName,
    this.latitude,
    this.longitude,
    required this.priority,
    required this.status,
    required this.images,
    required this.audioFiles,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.userProfile,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      locationName: json['location_name'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      priority: json['priority'] as String,
      status: json['status'] as String,
      images: List<String>.from(json['images'] ?? []),
      audioFiles: List<String>.from(json['audio_files'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['report_categories'] != null
          ? ReportCategory.fromJson(json['report_categories'])
          : null,
      userProfile: json['user_profiles'] != null
          ? UserProfile.fromJson(json['user_profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'priority': priority,
      'status': status,
      'images': images,
      'audio_files': audioFiles,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  String get statusDisplayName {
    switch (status) {
      case 'submitted':
        return 'Submitted';
      case 'under_review':
        return 'Under Review';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String get priorityDisplayName {
    switch (priority) {
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      case 'urgent':
        return 'Urgent';
      default:
        return priority;
    }
  }

  bool get hasLocation => latitude != null && longitude != null;
  bool get hasImages => images.isNotEmpty;
  bool get hasAudio => audioFiles.isNotEmpty;
  String get categoryName => category?.name ?? 'General';
  String get userName => userProfile?.fullName ?? 'Unknown User';
}

class ReportCategory {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String color;
  final bool isActive;
  final DateTime createdAt;

  ReportCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    required this.color,
    required this.isActive,
    required this.createdAt,
  });

  factory ReportCategory.fromJson(Map<String, dynamic> json) {
    return ReportCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String? ?? '#2563EB',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? address;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.address,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String? ?? 'citizen',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  bool get isAdmin => role == 'admin' || role == 'department_head';
  bool get isCitizen => role == 'citizen';
}
