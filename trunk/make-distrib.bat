setlocal

    echo --------------------------------
    echo -- START CREATE DISTRIBUTION PACK
    echo --------------------------------
    
    set DistribDir=%ThisPath%..\..\distrib\Debug console for ArmA2\ArmA2
    set DistribDir_modDir=%DistribDir%\@\sqf-calculator

    rd /S /Q "%DistribDir%"
    md "%DistribDir%"
    md "%DistribDir%\userconfig%"
    md "%DistribDir_modDir%\addons"

    xcopy /E /Y "%ThisPath%\userconfig" "%DistribDir%\userconfig%"
    xcopy /E /Y "%TargetAddonDir%" "%DistribDir_modDir%\addons"

    echo "%DistribDir_modDir%\addons\*.log"
    del "%DistribDir_modDir%\addons\*.log"

    copy "mod.cpp" "%DistribDir_modDir%\mod.cpp"

