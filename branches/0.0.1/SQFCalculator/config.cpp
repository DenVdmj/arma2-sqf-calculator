// ARMA2

class CfgPatches {
    class SQFCalculator {
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
    };
};

class SQFCalculatorTutorials {
    class VasiaPupinTutorial {
        init = "";
        include[] = {};
        tutor = "";
    };
};

class RscTitle;
class RscControlsGroup;
class RscEdit;
class RscToolbox;
class RscListBox;
class RscCombo;
class RscText;
class RscHTML;
class RscButton;
class RscPicture;
class RscStructuredText;
class RscStandardDisplay;
class RscDisplayEmpty;

#define setOnKeyDownEH onKeyDown = "if((_this select 1) == 41)then{ (_this select 0) call compile preprocessFileLineNumbers 'SQFCalculator\calc.sqf'; }; nil; ";

class RscDisplayInterrupt : RscStandardDisplay { setOnKeyDownEH };
class RscDisplayMPInterrupt : RscStandardDisplay { setOnKeyDownEH };
class RscDisplayArcadeMap { setOnKeyDownEH };
class RscDisplayArcadeUnit { setOnKeyDownEH };
class RscDisplayArcadeGroup { setOnKeyDownEH };
class RscDisplayArcadeWaypoint { setOnKeyDownEH };
class RscDisplayArcadeMarker { setOnKeyDownEH };
class RscDisplayArcadeSensor { setOnKeyDownEH };

#include "\SQFCalculator\dlg-defines.hpp"
#include "\SQFCalculator\dlg-calc.hpp"
