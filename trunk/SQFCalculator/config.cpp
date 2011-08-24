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
        action = "http://code.google.com/p/arma2-sqf-calculator/";
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

__EXEC( call compile preprocessFileLineNumbers '\SQFCalculator\getSettingsToParsingNamespace.sqf' );

#define setOnKeyDownEH_ onKeyDown = "if((_this select 1)==(parsingNamespace getVariable '/SQFCalculator/HKOpenConsole'))then{if(isNil{missionNamespace getVariable'\SQFCalculator\calc.sqf'})then{missionNamespace setVariable['\SQFCalculator\calc.sqf',compile preprocessFileLineNumbers'\SQFCalculator\calc.sqf']};(_this select 0)call(missionNamespace getVariable'\SQFCalculator\calc.sqf')}else{_this execVM'\ca\ui\scripts\mainmenuShortcuts.sqf'};nil";
#define setOnKeyDownEH onKeyDown = "if((_this select 1)==(parsingNamespace getVariable '/SQFCalculator/HKOpenConsole'))then{if(isNil{missionNamespace getVariable'\SQFCalculator\calc.sqf'})then{missionNamespace setVariable['\SQFCalculator\calc.sqf',compile preprocessFileLineNumbers'\SQFCalculator\calc.sqf']};(_this select 0)call(missionNamespace getVariable'\SQFCalculator\calc.sqf')};nil";

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
#include "dlg-defines.hpp"
#include "dlg-calc.hpp"

