@echo off
REM ============================================================================
REM AutoLab Monorepo - Complete Setup Script (Windows)
REM ============================================================================
REM Purpose: One-shot setup for Windows desktops
REM Usage: setup.bat
REM Requirements: Node.js installed (https://nodejs.org/)
REM ============================================================================

setlocal enabledelayedexpansion
cls

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

echo.
echo ================================================================================
echo AutoLab Monorepo - Windows Setup
echo ================================================================================
echo.

REM Check for Node.js
echo [*] Checking for Node.js...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Node.js is not installed or not in PATH
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo.
    echo After installation, please restart this script.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set "NODE_VERSION=%%i"
echo [OK] Node.js %NODE_VERSION% found

for /f "tokens=*" %%i in ('npm --version') do set "NPM_VERSION=%%i"
echo [OK] npm %NPM_VERSION% found

echo.
echo ================================================================================
echo [1] Installing Root Dependencies
echo ================================================================================
echo.

call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install root dependencies
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo [2] Installing Backend Dependencies
echo ================================================================================
echo.

cd "%PROJECT_DIR%apps\backend"
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install backend dependencies
    cd /d "%PROJECT_DIR%"
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo [3] Installing Dashboard Dependencies
echo ================================================================================
echo.

cd "%PROJECT_DIR%apps\dashboard"
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dashboard dependencies
    cd /d "%PROJECT_DIR%"
    pause
    exit /b 1
)

cd /d "%PROJECT_DIR%"

echo.
echo ================================================================================
echo [4] Setting Up Environment Files
echo ================================================================================
echo.

REM Backend .env
if not exist "apps\backend\.env" (
    if exist "apps\backend\.env.example" (
        type "apps\backend\.env.example" > "apps\backend\.env"
        echo [OK] Created backend .env from template
        echo.
        echo [WARNING] Update apps\backend\.env with your actual credentials:
        echo   - DATABASE_URL (Supabase PostgreSQL)
        echo   - JWT_SECRET
        echo   - GMAIL_USER and GMAIL_PASS
        echo   - HSP_SMS_USERNAME and HSP_SMS_API_KEY
        echo.
    )
)

REM Dashboard .env.local
if not exist "apps\dashboard\.env.local" (
    (
        echo # Dashboard Backend Configuration
        echo NEXT_PUBLIC_BACKEND_URL=http://localhost:3000
        echo.
        echo # Build Configuration
        echo BUILD_STANDALONE=
    ) > "apps\dashboard\.env.local"
    echo [OK] Created dashboard .env.local
)

echo.
echo ================================================================================
echo [5] Generating Prisma Client
echo ================================================================================
echo.

cd "%PROJECT_DIR%apps\backend"
call npm run prisma:generate
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Prisma client generation had issues, but continuing...
)

cd /d "%PROJECT_DIR%"

echo.
echo ================================================================================
echo Setup Complete! ^_^
echo ================================================================================
echo.
echo [OK] AutoLab environment is ready for development!
echo.
echo *** IMPORTANT - Next Steps ***
echo.
echo 1. Update Environment Variables
echo    - Edit: apps\backend\.env with database and email credentials
echo    - Edit: apps\dashboard\.env.local if needed
echo.
echo 2. Database Setup
echo    - Create PostgreSQL database (Supabase recommended: https://supabase.com)
echo    - Update DATABASE_URL in apps\backend\.env
echo    - Run: cd apps\backend ^& npm run prisma:migrate
echo.
echo 3. Start Development Servers
echo    Terminal 1 - Backend:
echo      cd apps\backend
echo      npm run dev
echo.
echo    Terminal 2 - Dashboard:
echo      cd apps\dashboard
echo      npm run dev
echo.
echo 4. Read Documentation
echo    - SETUP_GUIDES\README.md
echo    - SETUP_GUIDES\04_EXPRESS_BACKEND.md
echo    - SETUP_GUIDES\05_NEXT_JS_DASHBOARD.md
echo.
echo *** Optional Services ***
echo.
echo Redis (for OTP):
echo    - Download: https://github.com/microsoftarchive/redis/releases
echo    - Or use Docker: docker run -d -p 6379:6379 redis:latest
echo.

pause
