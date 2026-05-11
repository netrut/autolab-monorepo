class VehicleModel {
  final String id;
  final String userId;
  final String vehicleType; // 'car' | 'bike'
  final String brand;
  final String model;
  final int? year;
  final String? registrationNumber;
  final String? vehicleColor;
  final String? fuelType;
  final String? transmission;
  final String? chassisNumber;
  final bool? isActive;

  const VehicleModel({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.brand,
    required this.model,
    this.year,
    this.registrationNumber,
    this.vehicleColor,
    this.fuelType,
    this.transmission,
    this.chassisNumber,
    this.isActive,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        vehicleType: json['vehicle_type'] as String,
        brand: json['brand'] as String,
        model: json['model'] as String,
        year: json['year'] as int?,
        registrationNumber: json['registration_number'] as String?,
        vehicleColor: json['vehicle_color'] as String?,
        fuelType: json['fuel_type'] as String?,
        transmission: json['transmission'] as String?,
        chassisNumber: json['chassis_number'] as String?,
        isActive: json['is_active'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'vehicle_type': vehicleType,
        'brand': brand,
        'model': model,
        'year': year,
        'registration_number': registrationNumber,
        'vehicle_color': vehicleColor,
        'fuel_type': fuelType,
        'transmission': transmission,
        'chassis_number': chassisNumber,
      };

  bool get isCar => vehicleType.toLowerCase() == 'car';
  bool get isBike => vehicleType.toLowerCase() == 'bike';

  String get displayName => '$brand $model${year != null ? ' ($year)' : ''}';
}
