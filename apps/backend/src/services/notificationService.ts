import prisma from '../config/prisma.js';

interface CreateNotificationInput {
  userId: string;
  type: string;
  title: string;
  body: string;
  requestId?: string;
  entityType?: string;
  entityId?: string;
  channel?: string;
}

export async function createNotification(input: CreateNotificationInput): Promise<void> {
  try {
    await prisma.notification.create({
      data: {
        user_id:     input.userId,
        type:        input.type,
        title:       input.title,
        body:        input.body,
        request_id:  input.requestId  ?? null,
        entity_type: input.entityType ?? null,
        entity_id:   input.entityId   ?? null,
        channel:     input.channel    ?? 'app',
      },
    });
  } catch (err) {
    console.error('[Notification] Failed to create notification:', err);
  }
}
