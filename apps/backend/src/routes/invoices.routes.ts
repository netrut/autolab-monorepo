import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { invoiceController } from '../controllers/invoiceController.js';

const router: express.Router = express.Router();

router.use(authMiddleware);

router.post('/', invoiceController.create);
router.get('/service/:serviceId', invoiceController.getByServiceId);
router.get('/:id', invoiceController.getById);

export default router;
