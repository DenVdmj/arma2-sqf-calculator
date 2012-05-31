setlocal

set Z7=%ProgramFiles%\7-Zip\7z.exe
set Z7param= -m0=PPMd

set DistribDir=%ThisPath%..\..\distrib\Debug console for ArmA2 (revision %RevisionNumber%)
set DistribDir_modDir=%DistribDir%\ArmA2\@\sqf-calculator

:MakeDistrib

    echo --------------------------------
    echo -- START CREATE DISTRIBUTION PACK
    echo --------------------------------

    rmdir /S /Q "%DistribDir%"
    del /Q "%DistribDir%"

    if exist "%DistribDir%" (
        echo Error!
        exit
    )

    mkdir "%DistribDir%\ArmA2"
    mkdir "%DistribDir%\ArmA2\userconfig%"
    mkdir "%DistribDir_modDir%\addons"

    xcopy /E /Y "%ThisPath%\userconfig" "%DistribDir%\ArmA2\userconfig%"
    xcopy /E /Y "%TargetAddonDir%" "%DistribDir_modDir%\addons"

    rmdir /S /Q "%DistribDir_modDir%\addons\log"
    del "%DistribDir_modDir%\addons\*.log"

    copy "mod.cpp" "%DistribDir_modDir%\mod.cpp"

    del "%DistribDir%.7z"
    if exist "%DistribDir%.7z" (
        echo Error!
        exit
    )

    "%Z7%" a -r0 -t7z -mx9 %Z7param% -scsDOS -- "%DistribDir%.7z" "%DistribDir%\*"

goto :eof

