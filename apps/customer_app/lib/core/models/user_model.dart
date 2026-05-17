class UserModel {
  // Role IDs: 1=Admin, 2=Partner, 3=Customer, 4=Mechanic, 5=Driver
  static const int roleAdmin    = 1;
  static const int rolePartner  = 2;
  static const int roleCustomer = 3;
  static const int roleMechanic = 4;
  static const int roleDriver   = 5;

  final String id;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? avatarUrl;
  final int? roleId;
  final bool? isActive;

  const UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.avatarUrl,
    this.roleId,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String?,
        displayName: json['display_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        roleId: json['role_id'] as int?,
        isActive: json['is_active'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone_number': phoneNumber,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'role_id': roleId,
        'is_active': isActive,
      };

  // ── Role helpers ────────────────────────────────────────────────────────────

  bool get isAdmin    => roleId == roleAdmin;
  bool get isPartner  => roleId == rolePartner;
  bool get isCustomer => roleId == roleCustomer;
  bool get isMechanic => roleId == roleMechanic;
  bool get isDriver   => roleId == roleDriver;

  /// True for roles that can fill service forms (Partner + Mechanic)
  bool get canManageService => isAdmin || isPartner || isMechanic;

  /// True for roles that can manage bookings
  bool get canManageBookings => isAdmin || isPartner || isMechanic;

  /// True for customer-facing features
  bool get isEndCustomer => isCustomer || isDriver;

  // 8.8 — human-readable role label for all 5 roles
  String get roleLabel {
    switch (roleId) {
      case roleAdmin:    return 'Admin';
      case rolePartner:  return 'Partner';
      case roleCustomer: return 'Customer';
      case roleMechanic: return 'Mechanic';
      case roleDriver:   return 'Driver';
      default:           return 'User';
    }
  }

  String get roleDescription {
    switch (roleId) {
      case roleAdmin:    return 'Full system access';
      case rolePartner:  return 'Service centre owner';
      case roleCustomer: return 'Vehicle owner';
      case roleMechanic: return 'Service technician';
      case roleDriver:   return 'Fleet driver';
      default:           return '';
    }
  }
}
