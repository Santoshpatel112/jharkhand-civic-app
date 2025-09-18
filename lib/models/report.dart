import 'citizen.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final Citizen? citizen;
  final Location location;
  final List<String> images;
  final List<String> tags;
  final int views;
  final AssignedTo? assignedTo;
  final ResolutionDetails? resolutionDetails;
  final List<TimelineEntry> timeline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.citizen,
    required this.location,
    required this.images,
    required this.tags,
    required this.views,
    this.assignedTo,
    this.resolutionDetails,
    required this.timeline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      citizen: json['citizen'] != null ? Citizen.fromJson(json['citizen']) : null,
      location: Location.fromJson(json['location']),
      images: List<String>.from(json['images'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      assignedTo: json['assignedTo'] != null 
        ? AssignedTo.fromJson(json['assignedTo']) 
        : null,
      resolutionDetails: json['resolutionDetails'] != null 
        ? ResolutionDetails.fromJson(json['resolutionDetails']) 
        : null,
      timeline: (json['timeline'] as List?)
        ?.map((e) => TimelineEntry.fromJson(e))
        .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'citizen': citizen?.toJson(),
      'location': location.toJson(),
      'images': images,
      'tags': tags,
      'views': views,
      'assignedTo': assignedTo?.toJson(),
      'resolutionDetails': resolutionDetails?.toJson(),
      'timeline': timeline.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'submitted':
        return 'Submitted';
      case 'progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        return 'Unknown';
    }
  }

  String get priorityDisplay {
    switch (priority) {
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      default:
        return 'Medium';
    }
  }

  String get categoryDisplay {
    return category.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join(' ');
  }
}

class AssignedTo {
  final String department;
  final Officer? officer;
  final DateTime assignedDate;

  AssignedTo({
    required this.department,
    this.officer,
    required this.assignedDate,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      department: json['department'] ?? '',
      officer: json['officer'] != null ? Officer.fromJson(json['officer']) : null,
      assignedDate: DateTime.parse(json['assignedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'officer': officer?.toJson(),
      'assignedDate': assignedDate.toIso8601String(),
    };
  }
}

class Officer {
  final String id;
  final String name;
  final String designation;
  final String contact;

  Officer({
    required this.id,
    required this.name,
    required this.designation,
    required this.contact,
  });

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      contact: json['contact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'designation': designation,
      'contact': contact,
    };
  }
}

class ResolutionDetails {
  final DateTime resolvedDate;
  final String resolution;
  final String verifiedBy;

  ResolutionDetails({
    required this.resolvedDate,
    required this.resolution,
    required this.verifiedBy,
  });

  factory ResolutionDetails.fromJson(Map<String, dynamic> json) {
    return ResolutionDetails(
      resolvedDate: DateTime.parse(json['resolvedDate']),
      resolution: json['resolution'] ?? '',
      verifiedBy: json['verifiedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resolvedDate': resolvedDate.toIso8601String(),
      'resolution': resolution,
      'verifiedBy': verifiedBy,
    };
  }
}

class TimelineEntry {
  final String action;
  final String description;
  final DateTime date;
  final String by;

  TimelineEntry({
    required this.action,
    required this.description,
    required this.date,
    required this.by,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      by: json['by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'description': description,
      'date': date.toIso8601String(),
      'by': by,
    };
  }
}