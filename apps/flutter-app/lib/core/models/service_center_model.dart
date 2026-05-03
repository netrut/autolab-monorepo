class ServiceCenterModel {
  final String id;
  final String name;
  final String? description;
  final String phone;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final double? rating;
  final bool? isVerified;

  const ServiceCenterModel({
    required this.id,
    required this.name,
    required this.phone,
    this.description,
    this.email,
    this.address,
    this.city,
    this.state,
    this.rating,
    this.isVerified,
  });

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) =>
      ServiceCenterModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        description: json['description'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        isVerified: json['is_verified'] as bool?,
      );
}
