import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { serviceCenterOnboardingController as ctrl } from '../controllers/serviceCenterOnboardingController.js';

const router: express.Router = express.Router();
router.use(authMiddleware);

router.get('/mine',          ctrl.mine);
router.get('/:id',           ctrl.getOne);
router.post('/',             ctrl.createDraft);
router.put('/:id/details',   ctrl.updateDetails);
router.put('/:id/submit',    ctrl.submit);

export default router;
