import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { invoiceController } from '../controllers/invoiceController.js';

const router: express.Router = express.Router();

// Public — view invoice by ID (for shareable links)
router.get('/public/:id', invoiceController.getById);

router.use(authMiddleware);

router.get('/my', invoiceController.listMy);
router.post('/', invoiceController.create);
router.get('/service/:serviceId', invoiceController.getByServiceId);
router.get('/:id', invoiceController.getById);

export default router;
