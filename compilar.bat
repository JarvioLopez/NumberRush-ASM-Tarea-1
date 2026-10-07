@echo off
REM NUMBER RUSH - Unico compilador (Windows 64 siempre)
title Number Rush - Compilador
cd /d "%~dp0"

if not exist tools\nasm\nasm.exe (
  echo [ERROR] Falta tools\nasm\nasm.exe
  echo Reinstala la carpeta tools.
  pause
  exit /b 1
)
if not exist tools\golink\GoLink.exe (
  echo [ERROR] Falta tools\golink\GoLink.exe
  pause
  exit /b 1
)
if not exist NumberRush.asm (
  echo [ERROR] Falta NumberRush.asm
  pause
  exit /b 1
)

echo ----------------------------------------
echo  NUMBER RUSH - Compilando (Windows 64)
echo ----------------------------------------
tools\nasm\nasm.exe -v
echo Limpiando codigo viejo...
if exist NumberRush.exe del /q NumberRush.exe
if exist NumberRush.obj del /q NumberRush.obj

echo Ensamblando...
tools\nasm\nasm.exe -f win64 NumberRush.asm -o NumberRush.obj
if errorlevel 1 (
  echo [ERROR] Fallo NASM. Revisa el codigo arriba.
  pause
  exit /b 1
)

echo Enlazando...
tools\golink\GoLink.exe /console /entry start /fo NumberRush.exe NumberRush.obj kernel32.dll
if errorlevel 1 (
  echo [ERROR] Fallo GoLink.
  pause
  exit /b 1
)

if exist NumberRush.obj del /q NumberRush.obj

if exist NumberRush.exe (
  echo ----------------------------------------
  echo [OK] NumberRush.exe creado. Abriendo juego...
  echo ----------------------------------------
  pause
  NumberRush.exe
) else (
  echo [ERROR] No se genero el EXE
  pause
  exit /b 1
)
pause
