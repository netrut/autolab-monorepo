class BookingModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String serviceCenterId;
  final String serviceType;
  final DateTime bookingDate;
  final String? status;
  final String? notes;
  // Joined vehicle fields
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleRegNumber;
  final String? vehicleType;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.serviceCenterId,
    required this.serviceType,
    required this.bookingDate,
    this.status,
    this.notes,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleRegNumber,
    this.vehicleType,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final v = json['vehicles'] as Map<String, dynamic>?;
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      serviceCenterId: json['service_center_id'] as String,
      serviceType: json['service_type'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      vehicleBrand: v?['brand'] as String?,
      vehicleModel: v?['model'] as String?,
      vehicleRegNumber: v?['registration_number'] as String?,
      vehicleType: v?['vehicle_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        'service_center_id': serviceCenterId,
        'service_type': serviceType,
        'booking_date': bookingDate.toIso8601String(),
        'notes': notes,
      };

  /// Human-readable vehicle label: reg number or brand+model
  String get vehicleDisplayName {
    if (vehicleRegNumber != null && vehicleRegNumber!.isNotEmpty) {
      return vehicleRegNumber!;
    }
    final parts = [vehicleBrand, vehicleModel].where((s) => s != null && s.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : 'Vehicle';
  }
}
