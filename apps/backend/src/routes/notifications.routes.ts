import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { notificationController } from '../controllers/notificationController.js';

const router: express.Router = express.Router();
router.use(authMiddleware);

router.get('/',              notificationController.list);
router.get('/unread-count',  notificationController.unreadCount);
router.put('/read-all',      notificationController.markAllRead);
router.put('/:id/read',      notificationController.markRead);

export default router;
