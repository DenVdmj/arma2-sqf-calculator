//
// ������� ������ � ��������
//
// sqf-function funcCreateDialog
// Copyright (c) 2009 Denis Usenko (DenVdmj)
// MIT-style license

#define __GlobalDisplayStorage RLS_SQFConsole_Storage

if(isNil '__GlobalDisplayStorage')then{
    __GlobalDisplayStorage = [];
};

_funcCreateDialog = {

    private ["_rsc", "_parent", "_private", "_handlers", "_constructor", "_destructor"];

    disableSerialization;

    // default values
    _parent = objNull;
    _private = [];
    _handlers = [];
    _constructor = {};
    _destructor = {};

    // call user initialization code
    [] call _this;

    try {
        // type checking
        {
            if(isNil {_x select 0})then{ 
                throw format["Error of initialization: redefined any or undifined parameter: %1", _x select 1]; 
            }; 
            if(typeName (_x select 0) != typeName (_x select 2))then{ 
                throw format["Error of initialization: %1 parameter type mismatch, must be %2", _x select 1, typeName (_x select 2)] 
            };
        } foreach [
            [_rsc, '_rsc', ''],
            [_private, '_private', []],
            [_handlers, '_handlers', []],
            [_constructor, '_constructor', {}],
            [_destructor, '_destructor', {}]
        ];

        // hidden in the namespace to not interfere with user code variables
        _this = call {
            private [
                "_confDialog", "_idd", "_idc", "_display", "_dsplPrivateValues", "_dsplIDCByClassName",
                "_loadCode", "_saveCode", "_execEH", "_ehTpl", "_destructorTpl", "_dsplDataIndex",
                "_ehCtrls", "_ehCtrl", "_ehTypes", "_ehType", "_ehCode",
                "_handlersList", "_toArray", "_createDisplay"
            ];

            // try to turn the mission config, and game config
            // if it fails, the user asked the invalid resource name (_rsc)
            _confDialog = (missionConfigFile >> _rsc) call {
                if( isClass _this )then{ _this }else{
                    (configFile >> _rsc) call {
                        if( isClass _this )then{ _this }else{
                            throw ("Error of initialization: invalid _rsc: " + str _rsc)
                        };
                    };
                };
            };

            _idd = getNumber( _confDialog >> "idd" );

            // the idd must be valid, creating dialog must be successful, otherwise an error - user asked incorrect resource name (_rsc)
            if( _idd < 0 ) then {
                throw ("Error of initialization: invalid _rsc: " + str _rsc)
            };

            _createDisplay = {
                (switch (typeName _this) do {
                    case "STRING": { configFile >> _this  };
                    case "CONFIG": { getNumber(_this >> "idd") };
                    case "SCALAR": { findDisplay _this };
                    case "DISPLAY": { _this createDisplay _rsc; nil };
                    default { createDialog _rsc; nil }
                }) call _createDisplay
            };

            _parent call _createDisplay;

            _display = findDisplay _idd;

            if( isNull _display ) then {
                throw ("Error of initialization: null display")
            };

            // user-defined variable _private -- declare variables private dialogue; _dsplPrivateValues -- keeps the values of these variables
            _dsplIDCByClassName = [];
            _dsplPrivateValues = [];
            _dsplPrivateValues resize count _private; // not initialized variables -- nil

            _confDialog call {
                private ["_walk", "_idc"];
                _walk = {
                    if(isClass _this)then{
                        _idc = getNumber(_this >> "idc");
                        if(_idc > 0)then{
                            push(_private, "_ctrl" + configName _this);          // extend the list of names of private controls
                            push(_dsplPrivateValues, _display displayCtrl _idc); // write down their values
                            push(_dsplIDCByClassName, configName _this);
                            push(_dsplIDCByClassName, _idc);
                        };
                        for "_i" from 0 to count _this - 1 do {
                            _this select _i call _walk
                        };
                    }
                };
                _this call _walk;
            };

            _loadCode = ""; // loader of variables
            _saveCode = ""; // unloader of variables

            for "_i" from 0 to count _private - 1 do {
                _loadCode = _loadCode + format["%1 = __0 select %2;", _private select _i, _i];
                _saveCode = _saveCode + format["__0 set [%2, %1];", _private select _i, _i];
            };

            // create a template of native handlers
            // [__GlobalDisplayStorage, _dsplDataIndex, _ehIndex]
            _ehTpl = "__1 = %1 select %2; [__1 select 1, _this, (__1 select 2) select %3] call (__1 select 0)";
            _destructorTpl = "__1 = %1 select %2; [__1 select 1, _this, __1 select 3] call (__1 select 0); %1 set [%2, nil]";

            // create a template of common handlers
            // args: [_dsplPrivateValues, originThis, userEventHandler] call _execEH

            _execEH = compile format [
                'private "__1"; __0 = _this select 0; %1 call { private "__0"; (_this select 1) call (_this select 2) }; %2',
                _loadCode, _saveCode
            ];

            // find a free place (nil) in the __GlobalDisplayStorage
            _dsplDataIndex = 0 call {
                for "_i" from 0 to count __GlobalDisplayStorage do {
                    _this = __GlobalDisplayStorage select _i;
                    if( isNil "_this" )exitWith{_i};
                }
            };

            _handlersList = [];

            __GlobalDisplayStorage set [_dsplDataIndex, [_execEH, _dsplPrivateValues, _handlersList, _destructor]];

            _toArray = {
                if( isArr(_this) )then{ _this }else{ [_this] }
            };

            for "_i" from 0 to count _handlers - 3 step 3 do {

                _ehCtrls = _handlers select _i;
                _ehTypes = _handlers select _i+1;
                _ehCode  = _handlers select _i+2;

                push(_handlersList, _ehCode);

                {
                    _ehCtrl = _x;
                    {
                        _ehType = _x;

                        if(
                            typeName _ehCtrl != "String" ||
                            typeName _ehType != "String" ||
                            typeName _ehCode != "Code"
                        ) then {
                            throw format["Error of initialization: invalid _handlers type or order (index: %1)", _i];
                        };

                        [_ehType, format [_ehTpl, '__GlobalDisplayStorage', _dsplDataIndex, count _handlersList - 1]] call {
                            if( configName _confDialog == _ehCtrl )then{
                                _display displayAddEventHandler _this
                            } else {
                                _idc = (_dsplIDCByClassName find _ehCtrl) + 1 call { // find control's idc
                                    if(_this < 1)then{
                                        throw format["Error of initialization: one of the classes unavailable (%1)", _ehCtrl];
                                    } else {
                                        _dsplIDCByClassName select _this;
                                    };
                                };
                                _display displayCtrl _idc ctrlAddEventHandler _this
                            }
                        }
                    } foreach (_ehTypes call _toArray);
                } foreach (_ehCtrls call _toArray)
            };

            _display displayAddEventHandler ["Unload",
                format[_destructorTpl, '__GlobalDisplayStorage', _dsplDataIndex]
            ];

            [_dsplPrivateValues, _display, _constructor, _execEH]
        };

        // call constructor in current namespace (constructor is called from _execEH)
        _this call (_this select 3);

        "OK";

    } catch {
        _exception
    }
};

