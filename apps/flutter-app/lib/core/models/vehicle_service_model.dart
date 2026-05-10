import 'service_item_model.dart';

class VehicleServiceModel {
  final String id;
  final String vehicleId;
  final String userId;
  final DateTime serviceDate;
  final DateTime? nextServiceDate;
  final double? odometerKm;
  final String serviceType;
  final double labourCost;
  final double totalCost;
  final String? notes;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ServiceItemModel> items;
  // Joined vehicle info
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? registrationNumber;
  final String? vehicleType;

  const VehicleServiceModel({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.serviceDate,
    this.nextServiceDate,
    this.odometerKm,
    required this.serviceType,
    required this.labourCost,
    required this.totalCost,
    this.notes,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
    this.vehicleBrand,
    this.vehicleModel,
    this.registrationNumber,
    this.vehicleType,
  });

  factory VehicleServiceModel.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'] as Map<String, dynamic>?;
    return VehicleServiceModel(
      id: json['id'] as String,
      vehicleId: json['vehicle_id'] as String,
      userId: json['user_id'] as String,
      serviceDate: DateTime.parse(json['service_date'] as String),
      nextServiceDate: json['next_service_date'] != null
          ? DateTime.tryParse(json['next_service_date'] as String)
          : null,
      odometerKm: double.tryParse(json['odometer_km']?.toString() ?? ''),
      serviceType: json['service_type'] as String? ?? 'general',
      labourCost: double.tryParse(json['labour_cost']?.toString() ?? '0') ?? 0,
      totalCost: double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'completed',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ServiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vehicleBrand: vehicle?['brand'] as String?,
      vehicleModel: vehicle?['model'] as String?,
      registrationNumber: vehicle?['registration_number'] as String?,
      vehicleType: vehicle?['vehicle_type'] as String?,
    );
  }

  String get vehicleDisplayName =>
      '${vehicleBrand ?? ''} ${vehicleModel ?? ''}'.trim();

  static const List<String> serviceTypes = ['general', 'major', 'emergency'];
}

// Vehicle with service status (for the search/service screen)
class VehicleWithServiceStatus {
  final String id;
  final String userId;
  final String vehicleType;
  final String brand;
  final String model;
  final int? year;
  final String? registrationNumber;
  final String? fuelType;
  final String serviceStatus; // upcoming | due | completed | no_service
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;
  final int totalServices;

  const VehicleWithServiceStatus({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.brand,
    required this.model,
    this.year,
    this.registrationNumber,
    this.fuelType,
    required this.serviceStatus,
    this.lastServiceDate,
    this.nextServiceDate,
    required this.totalServices,
  });

  factory VehicleWithServiceStatus.fromJson(Map<String, dynamic> json) =>
      VehicleWithServiceStatus(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        vehicleType: json['vehicle_type'] as String,
        brand: json['brand'] as String,
        model: json['model'] as String,
        year: json['year'] as int?,
        registrationNumber: json['registration_number'] as String?,
        fuelType: json['fuel_type'] as String?,
        serviceStatus: json['service_status'] as String? ?? 'no_service',
        lastServiceDate: json['last_service_date'] != null
            ? DateTime.tryParse(json['last_service_date'] as String)
            : null,
        nextServiceDate: json['next_service_date'] != null
            ? DateTime.tryParse(json['next_service_date'] as String)
            : null,
        totalServices: json['total_services'] as int? ?? 0,
      );

  bool get isCar => vehicleType.toLowerCase() == 'car';
  String get displayName => '$brand $model${year != null ? ' ($year)' : ''}';
}
