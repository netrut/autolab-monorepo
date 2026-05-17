import 'vehicle_service_model.dart';

class InvoiceModel {
  final String id;
  final String serviceId;
  final String vehicleId;
  final String userId;
  final String? serviceCenterId;
  final String invoiceNumber;
  final DateTime serviceDate;
  final double totalCost;
  final double labourCost;
  final double itemsCost;
  final String? footerText;
  final String? notes;
  final DateTime? createdAt;

  // Nested service record (included by backend)
  final VehicleServiceModel? service;

  const InvoiceModel({
    required this.id,
    required this.serviceId,
    required this.vehicleId,
    required this.userId,
    this.serviceCenterId,
    required this.invoiceNumber,
    required this.serviceDate,
    required this.totalCost,
    required this.labourCost,
    required this.itemsCost,
    this.footerText,
    this.notes,
    this.createdAt,
    this.service,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        serviceId: json['service_id'] as String,
        vehicleId: json['vehicle_id'] as String,
        userId: json['user_id'] as String,
        serviceCenterId: json['service_center_id'] as String?,
        invoiceNumber: json['invoice_number'] as String,
        serviceDate: DateTime.parse(json['service_date'] as String),
        totalCost:
            double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
        labourCost:
            double.tryParse(json['labour_cost']?.toString() ?? '0') ?? 0,
        itemsCost:
            double.tryParse(json['items_cost']?.toString() ?? '0') ?? 0,
        footerText: json['footer_text'] as String?,
        notes: json['notes'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
        service: json['service'] != null
            ? VehicleServiceModel.fromJson(
                json['service'] as Map<String, dynamic>)
            : null,
      );
}
