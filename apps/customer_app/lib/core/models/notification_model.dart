enum NotificationType {
  request('request'),
  serviceDue('service_due'),
  bookingUpdate('booking_update'),
  serviceComplete('service_complete'),
  invoice('invoice'),
  system('system');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String s) =>
      NotificationType.values.firstWhere((e) => e.value == s,
          orElse: () => NotificationType.system);
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final String? requestId;
  final String? entityType;
  final String? entityId;
  final bool isRead;
  final String channel;
  final DateTime? sentAt;
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.requestId,
    this.entityType,
    this.entityId,
    required this.isRead,
    required this.channel,
    this.sentAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        type: NotificationType.fromString(json['type'] as String),
        title: json['title'] as String,
        body: json['body'] as String,
        requestId: json['request_id'] as String?,
        entityType: json['entity_type'] as String?,
        entityId: json['entity_id'] as String?,
        isRead: json['is_read'] as bool? ?? false,
        channel: json['channel'] as String? ?? 'app',
        sentAt: json['sent_at'] != null
            ? DateTime.tryParse(json['sent_at'] as String)
            : null,
        readAt: json['read_at'] != null
            ? DateTime.tryParse(json['read_at'] as String)
            : null,
      );

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) =>
      NotificationModel(
        id: id, userId: userId, type: type, title: title, body: body,
        requestId: requestId, entityType: entityType, entityId: entityId,
        isRead: isRead ?? this.isRead, channel: channel,
        sentAt: sentAt, readAt: readAt ?? this.readAt,
      );
}
