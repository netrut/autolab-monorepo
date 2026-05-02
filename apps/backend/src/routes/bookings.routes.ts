import express from "express";
import { authMiddleware } from "../middleware/auth.middleware.js";
import { bookingController } from "../controllers/bookingController.js";

const router: express.Router = express.Router();

router.use(authMiddleware);

router.get("/", bookingController.list);
router.get("/:id", bookingController.getById);
router.post("/", bookingController.create);
router.put("/:id", bookingController.update);
router.delete("/:id", bookingController.cancel);

export default router;
