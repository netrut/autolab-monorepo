import express from "express";
import { optionalAuthMiddleware } from "../middleware/auth.middleware.js";
import { vehicleController } from "../controllers/vehicleController.js";

const router: express.Router = express.Router();

router.use(optionalAuthMiddleware);

router.get("/lookup", vehicleController.lookupByReg);
router.get("/", vehicleController.list);
router.get("/:id", vehicleController.getById);
router.post("/", vehicleController.create);
router.put("/:id", vehicleController.update);
router.delete("/:id", vehicleController.remove);

export default router;
