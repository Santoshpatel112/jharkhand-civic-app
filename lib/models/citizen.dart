class Citizen {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Location? location;
  final DateTime? dateOfBirth;
  final String? gender;
  final String status;
  final bool isVerified;
  final int totalReports;
  final int resolvedReports;
  final double rating;
  final DateTime? lastLoginDate;
  final DateTime createdAt;

  Citizen({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.location,
    this.dateOfBirth,
    this.gender,
    required this.status,
    required this.isVerified,
    required this.totalReports,
    required this.resolvedReports,
    required this.rating,
    this.lastLoginDate,
    required this.createdAt,
  });

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      dateOfBirth: json['dateOfBirth'] != null 
        ? DateTime.parse(json['dateOfBirth']) 
        : null,
      gender: json['gender'],
      status: json['status'] ?? 'active',
      isVerified: json['isVerified'] ?? false,
      totalReports: json['totalReports'] ?? 0,
      resolvedReports: json['resolvedReports'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      lastLoginDate: json['lastLoginDate'] != null 
        ? DateTime.parse(json['lastLoginDate']) 
        : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location?.toJson(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'status': status,
      'isVerified': isVerified,
      'totalReports': totalReports,
      'resolvedReports': resolvedReports,
      'rating': rating,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Citizen copyWith({
    String? name,
    String? phone,
    Location? location,
    DateTime? dateOfBirth,
    String? gender,
    String? status,
    bool? isVerified,
    int? totalReports,
    int? resolvedReports,
    double? rating,
    DateTime? lastLoginDate,
  }) {
    return Citizen(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      totalReports: totalReports ?? this.totalReports,
      resolvedReports: resolvedReports ?? this.resolvedReports,
      rating: rating ?? this.rating,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      createdAt: createdAt,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String? area;
  final String? city;
  final String? state;
  final String? pincode;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.area,
    this.city,
    this.state,
    this.pincode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      area: json['area'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }
}