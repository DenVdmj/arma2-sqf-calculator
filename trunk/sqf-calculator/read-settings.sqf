private '_HKOpenConsole';
call compile preprocessFileLineNumbers '\userconfig\sqf-calculator\settings';
if (isNil "_HKOpenConsole" ) then {
    _HKOpenConsole = 41;
};
parsingNamespace setVariable ['/sqf-calculator/HKOpenConsole', _HKOpenConsole];