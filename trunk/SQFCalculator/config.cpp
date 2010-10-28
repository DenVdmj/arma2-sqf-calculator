// ARMA2

class CfgPatches {
    class SQFCalculator {
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
        requiredAddons[] = {"CAUI"};
    };
};

class CfgMods {
    class RLS {
        dir = "@\SQFCalculator";
        name = "SQF-Calculator";
        picture = "";
        hidePicture = "true";
        hideName = "true";
        actionName = "Website";
        action = "http://www.google.ru/search?q=arma2+DenVdmj+SQFCalculator";
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
//class RscStandardDisplay;
class RscDisplayEmpty;

#define setOnKeyDownEH onKeyDown = "if((_this select 1) == 41) then { (_this select 0) call compile preprocessFileLineNumbers '\SQFCalculator\calc.sqf'; }; nil; ";

class RscStandardDisplay { setOnKeyDownEH };
class RscDisplayMain : RscStandardDisplay { setOnKeyDownEH };
class RscDisplayInterrupt : RscStandardDisplay { setOnKeyDownEH };
class RscDisplayMPInterrupt : RscStandardDisplay { setOnKeyDownEH };
class RscDisplayArcadeMap { setOnKeyDownEH };
class RscDisplayArcadeUnit { setOnKeyDownEH };
class RscDisplayArcadeGroup { setOnKeyDownEH };
class RscDisplayArcadeWaypoint { setOnKeyDownEH };
class RscDisplayArcadeMarker { setOnKeyDownEH };
class RscDisplayArcadeSensor { setOnKeyDownEH };
class RscDisplayArcadeModules { setOnKeyDownEH };
class RscDisplayMissionEditor  { setOnKeyDownEH };
class RscGroupRootMenu { setOnKeyDownEH };
class RscDisplayMainMap { setOnKeyDownEH };
class RscDisplayTemplateLoad { setOnKeyDownEH };

#include "dlg-defines.hpp"
#include "dlg-calc.hpp"
