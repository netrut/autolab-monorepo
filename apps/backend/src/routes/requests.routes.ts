import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { requestController } from '../controllers/requestController.js';

const router: express.Router = express.Router();
router.use(authMiddleware);

router.post('/',                       requestController.send);
router.get('/received',                requestController.listReceived);
router.get('/sent',                    requestController.listSent);
router.get('/pending-count',           requestController.pendingCount);
router.put('/:id/accept',              requestController.accept);
router.put('/:id/reject',              requestController.reject);
router.put('/:id/cancel',              requestController.cancel);

export default router;
