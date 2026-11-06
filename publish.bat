@echo off
chcp 65001 >nul
cd /d "%~dp0"
set HTTP_PROXY=
set HTTPS_PROXY=
set http_proxy=
set https_proxy=

echo ====================================
echo  Delivery Note Workbench - Publish
echo ====================================
echo.

if not exist ".deploy" mkdir ".deploy"

echo [1/4] Copy index.html to deploy folder...
copy /Y "index.html" ".deploy\index.html" >nul
if errorlevel 1 goto fail

echo [2/4] Upload to Cloudflare Pages...
call npx --yes wrangler@latest pages deploy .deploy --project-name=delivery-note-workbench --branch=main --commit-dirty=true
if errorlevel 1 goto fail

echo.
echo [3/4] Commit to local git...
git add -A
git commit -m "update site" >nul 2>&1

echo [4/4] Push to GitHub...
git push origin main
if errorlevel 1 echo    (push failed - not fatal, site is already online)

echo.
echo ====================================
echo  DONE. Site: https://delivery-note-workbench-eiw.pages.dev
echo ====================================
pause
exit /b 0

:fail
echo.
echo ====================================
echo  FAILED - see error message above
echo ====================================
pause
exit /b 1
