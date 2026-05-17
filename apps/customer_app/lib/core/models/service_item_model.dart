class ServiceItemModel {
  final String id;
  final String serviceId;
  final String itemName;
  final String status;
  final double cost;
  final String? notes;
  final DateTime? expiryDate;
  final DateTime? createdAt;

  const ServiceItemModel({
    required this.id,
    required this.serviceId,
    required this.itemName,
    required this.status,
    required this.cost,
    this.notes,
    this.expiryDate,
    this.createdAt,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) => ServiceItemModel(
        id: json['id'] as String,
        serviceId: json['service_id'] as String,
        itemName: json['item_name'] as String,
        status: json['status'] as String,
        cost: double.tryParse(json['cost']?.toString() ?? '0') ?? 0,
        notes: json['notes'] as String?,
        expiryDate: json['expiry_date'] != null
            ? DateTime.tryParse(json['expiry_date'] as String)
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'status': status,
        'cost': cost,
        if (notes != null) 'notes': notes,
        if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
      };

  ServiceItemModel copyWith({
    String? itemName,
    String? status,
    double? cost,
    String? notes,
    DateTime? expiryDate,
  }) =>
      ServiceItemModel(
        id: id,
        serviceId: serviceId,
        itemName: itemName ?? this.itemName,
        status: status ?? this.status,
        cost: cost ?? this.cost,
        notes: notes ?? this.notes,
        expiryDate: expiryDate ?? this.expiryDate,
        createdAt: createdAt,
      );

  static const List<String> statusOptions = [
    'Good',
    'Changed',
    'Repaired',
    'Replaced',
    'Needs Attention',
    'Checked',
    'Topped Up',
    'Cleaned',
  ];
}

// Used for new items being added (no id yet)
class ServiceItemInput {
  final String itemName;
  final String status;
  final double cost;
  final String? notes;
  final DateTime? expiryDate;

  ServiceItemInput({
    required this.itemName,
    required this.status,
    this.cost = 0,
    this.notes,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'status': status,
        'cost': cost,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
        if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
      };

  ServiceItemInput copyWith({
    String? itemName,
    String? status,
    double? cost,
    String? notes,
    DateTime? expiryDate,
  }) =>
      ServiceItemInput(
        itemName: itemName ?? this.itemName,
        status: status ?? this.status,
        cost: cost ?? this.cost,
        notes: notes ?? this.notes,
        expiryDate: expiryDate ?? this.expiryDate,
      );
}

class CatalogueItem {
  final String id;
  final String name;
  final String vehicleType;
  final String category;
  final int sortOrder;

  const CatalogueItem({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.category,
    required this.sortOrder,
  });

  factory CatalogueItem.fromJson(Map<String, dynamic> json) => CatalogueItem(
        id: json['id'] as String,
        name: json['name'] as String,
        vehicleType: json['vehicle_type'] as String,
        category: json['category'] as String,
        sortOrder: json['sort_order'] as int? ?? 0,
      );
}
