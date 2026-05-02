import express from "express";
import { authMiddleware, adminMiddleware } from "../middleware/auth.middleware.js";
import { serviceCenterController } from "../controllers/serviceCenterController.js";

const router: express.Router = express.Router();

// Public — anyone can browse centers
router.get("/", serviceCenterController.list);
router.get("/:id", serviceCenterController.getById);

// Admin only — create/update/delete
router.post("/", authMiddleware, adminMiddleware, serviceCenterController.create);
router.put("/:id", authMiddleware, adminMiddleware, serviceCenterController.update);
router.delete("/:id", authMiddleware, adminMiddleware, serviceCenterController.remove);

export default router;
