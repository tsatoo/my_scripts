@echo off
setlocal enabledelayedexpansion

:: DB設定
set DB_NAME=test_db
set DB_USER=test_user
set CONTAINER_NAME=psql

:: 出力ディレクトリ
set OUTPUT_DIR=.\db_dumps
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

:: 引数取得（ラベル）
set LABEL=%1

:: タイムスタンプ
for /f %%A in ('powershell -command "Get-Date -Format yyyyMMddHHmm"') do set TIMESTAMP=%%A

:: ファイル名作成
if defined LABEL (
    set FILENAME=dump_%LABEL%_%TIMESTAMP%.sql
) else (
    set FILENAME=dump_%TIMESTAMP%.sql
)

:: dump実行（Dockerコンテナ内でpg_dump）
docker exec %CONTAINER_NAME% pg_dump -U %DB_USER% %DB_NAME% > "%OUTPUT_DIR%\%FILENAME%"
set RESULT=%ERRORLEVEL%

:: 結果表示
if %RESULT%==0 (
    echo Dumped: %OUTPUT_DIR%\%FILENAME%
) else (
    echo Dump failed: %OUTPUT_DIR%\%FILENAME%
)

endlocal
