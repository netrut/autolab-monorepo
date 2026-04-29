postgresql://postgres:AutoLab@2024#@db.kdbcukdrbwwsgntrsvdi.supabase.co:5432/postgres

host:
db.kdbcukdrbwwsgntrsvdi.supabase.co

port:
5432

database:
postgres

user:
postgres

-------------------------------------------


bravo
Api key 
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

 MCP server API key
eyJhcGlfa2V5IjoieGtleXNpYi00ODkyYTA3ODcwZGM3MTA4MjgxMDNiZDIwYmU4ZTI4YzkyMWZjYzRmZWRkZjZkZWQwNGQ1ZDVkNTE5NDU4ZDE3LXp4RWRIdEc1cnFaSVh2eEYifQ==

----------------------------------

  const smsApiUrl = `https://sms.hspmedianetwork.com/sendSMS?username=ludoveer&message=OTP%20for%20login%20HireForCare%20is%20${otp}.&sendername=HIFCAR&smstype=TRANS&numbers=91${phone}&apikey=d35d1647-fb94-4ad5-843c-65e35c2eb93a`;

  ---------------------------------

Restart backend port
  $port=3000; $repo='D:\komal\GitHub\autolab-monorepo'; $backend=Join-Path $repo 'apps\backend'; $pids=(Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique); if($pids){$pids | ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }}; Set-Location $backend; $env:DATABASE_URL='postgresql://postgres.kdbcukdrbwwsgntrsvdi:AutoLab%402024%23@aws-1-ap-northeast-1.pooler.supabase.com:5432/postgres?schema=autolab_api'; npm run dev