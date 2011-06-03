private '_HKOpenConsole';
call compile preprocessFileLineNumbers '\userconfig\SQFCalculator\settings';
if (isNil "_HKOpenConsole" ) then { 
    _HKOpenConsole = 41;
};
parsingNamespace setVariable ['/SQFCalculator/HKOpenConsole', _HKOpenConsole];