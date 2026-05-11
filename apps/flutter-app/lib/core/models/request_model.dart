enum RequestType {
  vehicleAccess('vehicle_access'),
  serviceCenterJoin('service_center_join'),
  customerInvite('customer_invite'),
  partnerInvite('partner_invite');

  final String value;
  const RequestType(this.value);

  static RequestType fromString(String s) =>
      RequestType.values.firstWhere((e) => e.value == s,
          orElse: () => RequestType.vehicleAccess);

  String get label {
    switch (this) {
      case vehicleAccess:     return 'Vehicle Access';
      case serviceCenterJoin: return 'Join Service Centre';
      case customerInvite:    return 'Customer Invite';
      case partnerInvite:     return 'Partner Invite';
    }
  }
}

enum RequestStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected'),
  cancelled('cancelled');

  final String value;
  const RequestStatus(this.value);

  static RequestStatus fromString(String s) =>
      RequestStatus.values.firstWhere((e) => e.value == s,
          orElse: () => RequestStatus.pending);
}

class RequestUserInfo {
  final String id;
  final String? displayName;
  final String? email;

  const RequestUserInfo({required this.id, this.displayName, this.email});

  factory RequestUserInfo.fromJson(Map<String, dynamic> json) =>
      RequestUserInfo(
        id: json['id'] as String,
        displayName: json['display_name'] as String?,
        email: json['email'] as String?,
      );

  String get name => displayName ?? email ?? id;
}

class RequestModel {
  final String id;
  final RequestType type;
  final String fromUserId;
  final String? toUserId;
  final String entityType; // 'vehicle' | 'service_center'
  final String entityId;
  final String role;
  final RequestStatus status;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RequestUserInfo? fromUser;
  final RequestUserInfo? toUser;

  const RequestModel({
    required this.id,
    required this.type,
    required this.fromUserId,
    this.toUserId,
    required this.entityType,
    required this.entityId,
    required this.role,
    required this.status,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.fromUser,
    this.toUser,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json['id'] as String,
        type: RequestType.fromString(json['type'] as String),
        fromUserId: json['from_user_id'] as String,
        toUserId: json['to_user_id'] as String?,
        entityType: json['entity_type'] as String,
        entityId: json['entity_id'] as String,
        role: json['role'] as String? ?? 'user',
        status: RequestStatus.fromString(json['status'] as String),
        message: json['message'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'] as String)
            : null,
        fromUser: json['from_user'] != null
            ? RequestUserInfo.fromJson(
                json['from_user'] as Map<String, dynamic>)
            : null,
        toUser: json['to_user'] != null
            ? RequestUserInfo.fromJson(
                json['to_user'] as Map<String, dynamic>)
            : null,
      );
}
