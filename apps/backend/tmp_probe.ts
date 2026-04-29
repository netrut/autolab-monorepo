import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();
prisma.user.findFirst({ where: { OR: [{ email: "probe@example.com" }, { phone: "+911" }] } })
  .then((r) => { console.log("QUERY_OK", r); })
  .catch((e) => { console.error("QUERY_ERR", e?.code, e?.message); process.exitCode = 1; })
  .finally(async () => { await prisma.$disconnect(); });
