class BookingModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String serviceCenterId;
  final String serviceType;
  final DateTime bookingDate;
  final String? status;
  final String? notes;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.serviceCenterId,
    required this.serviceType,
    required this.bookingDate,
    this.status,
    this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        vehicleId: json['vehicle_id'] as String,
        serviceCenterId: json['service_center_id'] as String,
        serviceType: json['service_type'] as String,
        bookingDate: DateTime.parse(json['booking_date'] as String),
        status: json['status'] as String?,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        'service_center_id': serviceCenterId,
        'service_type': serviceType,
        'booking_date': bookingDate.toIso8601String(),
        'notes': notes,
      };
}
