class UserModel {
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

  bool get isAdmin => roleId == 1;
}
