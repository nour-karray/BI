@echo off
setlocal

set "DOTNET_ROOT=C:\Program Files\dotnet"
set "PATH=%DOTNET_ROOT%;%PATH%"
set "VSDEVENV=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
set "SOLUTION=%~dp0HRAnalyticsDashboard.sln"

if not exist "%VSDEVENV%" (
    echo Visual Studio 2022 n'a pas ete trouve a cet emplacement:
    echo %VSDEVENV%
    pause
    exit /b 1
)

if not exist "%SOLUTION%" (
    echo La solution n'a pas ete trouvee:
    echo %SOLUTION%
    pause
    exit /b 1
)

start "" "%VSDEVENV%" "%SOLUTION%"
