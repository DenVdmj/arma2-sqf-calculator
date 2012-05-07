#define __processListRef VDMJ_SQFConsole_processListRef

_this spawn {

    disableSerialization;

    _display = _this select 0;

    _ctrlXMLText = _display displayCtrl 100;
    _ctrlXMLText ctrlSetPosition [safeZoneX + .01, safeZoneY + .02, .35, safeZoneH];
    _ctrlXMLText ctrlCommit 0;

    _tpl = "<t size='0.8' align='right' color='#ffffff'>%1</t><br />"+
        "<t size='0.4' align='right' color='#ffffff'>---------------------------------------------</t><br />";

    waitUntil {
        _xmlList = [];
        {
            _value = call _x;
            if( !isNil "_value" ) then {
                _xmlList set [count _xmlList, parseText format [_tpl, _value]];
            };
        } foreach (__processListRef select 0);
        _ctrlXMLText ctrlSetStructuredText composeText _xmlList;
        sleep .05;
        false;
    };

    _display closeDisplay 1;
};
