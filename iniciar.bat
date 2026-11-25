@echo off
chcp 65001 >nul
title TESE Pickup
cd /d "%~dp0"

where git >nul 2>nul || (echo Falta instalar Git: https://git-scm.com/download/win & pause & exit /b)
where node >nul 2>nul || (echo Falta instalar Node.js LTS: https://nodejs.org & pause & exit /b)
where flutter >nul 2>nul || if exist "C:\flutter\bin\flutter.bat" set "PATH=%PATH%;C:\flutter\bin"
where flutter >nul 2>nul || (echo Falta instalar Flutter y agregar C:\flutter\bin al PATH & pause & exit /b)

echo === 1. Trayendo la version con todo unido ===
git fetch origin
git checkout dev-d-integracion
git pull origin dev-d-integracion

echo === 2. Instalando backend ===
cd backend
call npm install
if errorlevel 1 (echo Error en npm install & pause & exit /b)

if "%1"=="nuevo" goto crear
if exist "..\.bd_creada" goto arrancar
:crear
echo === 3. Creando base de datos ===
call npm run crear-bd
if errorlevel 1 (echo No se pudo crear la base. Revisa que PostgreSQL este prendido y la contrasena sea postgres & pause & exit /b)
echo ok > "..\.bd_creada"

:arrancar
echo === 4. Arrancando backend en otra ventana ===
start "Backend TESE (no cerrar)" cmd /k npm start
timeout /t 8 >nul

echo === 5. Abriendo pagina web ===
cd ..\web-admin
call flutter pub get
call flutter run -d chrome
pause