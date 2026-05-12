import express from 'express';
import { authMiddleware } from '../middleware/auth.middleware.js';
import prisma from '../config/prisma.js';

const router: express.Router = express.Router();

// GET /api/options — public, returns all options as key→value map
router.get('/', async (_req, res) => {
  try {
    const rows = await prisma.option.findMany();
    const map: Record<string, string> = {};
    for (const r of rows) map[r.key] = r.value;
    res.json(map);
  } catch {
    res.status(500).json({ error: 'Failed to fetch options' });
  }
});

// PUT /api/options/:key — admin only (authenticated for now)
router.put('/:key', authMiddleware, async (req: any, res) => {
  try {
    const { value } = req.body as { value: string };
    const option = await prisma.option.update({
      where: { key: req.params.key },
      data: { value, updated_at: new Date() },
    });
    res.json(option);
  } catch {
    res.status(404).json({ error: 'Option key not found' });
  }
});

export default router;
