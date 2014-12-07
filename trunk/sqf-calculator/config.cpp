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
    class SQFCalculator {
        dir         = "sqf-calculator";
        name        = "$str/vdmj/sqf-calculator/mod.cpp.name";
        picture     = ;
        hidePicture = 0;
        hideName    = 0;
        actionName  = "$str/vdmj/sqf-calculator/mod.cpp.action-name";
        action      = "http://code.google.com/p/arma2-sqf-calculator/";
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

__EXEC( call compile preprocessFileLineNumbers '\sqf-calculator\read-settings.sqf' );

#define setOnKeyDownEH_ onKeyDown = "if((_this select 1)==(parsingNamespace getVariable '/sqf-calculator/HKOpenConsole'))then{if(isNil{missionNamespace getVariable'\sqf-calculator\calc.sqf'})then{missionNamespace setVariable['\sqf-calculator\calc.sqf',compile preprocessFileLineNumbers'\sqf-calculator\calc.sqf']};(_this select 0)call(missionNamespace getVariable'\sqf-calculator\calc.sqf')}else{_this execVM'\ca\ui\scripts\mainmenuShortcuts.sqf'};nil";
#define setOnKeyDownEH onKeyDown = "if((_this select 1)==(parsingNamespace getVariable '/sqf-calculator/HKOpenConsole'))then{if(isNil{missionNamespace getVariable'\sqf-calculator\calc.sqf'})then{missionNamespace setVariable['\sqf-calculator\calc.sqf',compile preprocessFileLineNumbers'\sqf-calculator\calc.sqf']};(_this select 0)call(missionNamespace getVariable'\sqf-calculator\calc.sqf')};nil";

class RscStandardDisplay { setOnKeyDownEH };
class RscDisplayMain : RscStandardDisplay { setOnKeyDownEH_ };
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
class RscDisplayGear { setOnKeyDownEH };
class RscDisplayDiary { setOnKeyDownEH };

#include "dlg-defines.hpp"
#include "dlg-calc.hpp"
