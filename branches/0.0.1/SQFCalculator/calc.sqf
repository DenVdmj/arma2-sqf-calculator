// sqf
// Веселый Калькулятор - Calculador Alegre
// Copyright (c) 2009 Denis Usenko (DenVdmj)
// MIT-style license

#include "\SQFCalculator\common.hpp"
#include "\SQFCalculator\dik-codes.hpp"
private "_funcCreateDialog";
#include "\SQFCalculator\rlsFuncCreateDialog.sqf";

_self = _this;
//diag_log
({
    _rsc = "RscVdmjSqfCalculator";
    _parent = _self;
    _private = [
        // variables
        "_privateNames",
        "_commandsHistory",
        "_hotKeysRegister",
        "_accTime",
        "_soundVolume",
        "_windowStruct",
        "_resultCacheText",
        "_resultCacheDepth",
        // function
        "_updateHistory",
        "_delFromHistory",
        "_addToHistory",
        "_execFromHistory",
        "_setActiveWin",
        "_getActiveWinSibling",
        "_execExpression",
        "_displayValue",
        "_funcJoinString",
        "_copyFromListBoxToClipboard",
        "_applySettingsFromFile"
    ];

    _handlers = [
        _rsc, "KeyDown", {  // Display's KeyDown handler (args: Control, KeyCodes, Shift, Ctrl, Alt)
            if(arg(4))then{
                private "_keyCode";
                _keyCode = arg(1);
                _hotKeysRegister find _keyCode call {
                    if(_this > 0)then{
                        switch (_hotKeysRegister select (_this - 1)) do {
                            case "HKLeft" :   { - 1 call _getActiveWinSibling call _setActiveWin };
                            case "HKRight" :  { + 1 call _getActiveWinSibling call _setActiveWin };
                            case "HKInput" :    { ctrlSetFocus _ctrlInputText };
                            case "HKDisplay" :  { 0 call _setActiveWin };
                            case "HKDisplay2" : { 1 call _setActiveWin };
                            case "HKHistory" :  { 2 call _setActiveWin };
                            case "HKDemo" :     { 3 call _setActiveWin };
                            case "HKHelp" :     { 4 call _setActiveWin };
                        };
                    };
                };
            };
        },
        "InputText", "KeyDown", {
            if(arg(1) == DIK_RETURN)then{
                ctrlText _ctrlInputText call {
                    [_this call _execExpression] call _displayValue;
                    _this call _addToHistory;
                };
            };
        },
        "SelectWin", "ToolBoxSelChanged", {
            arg(1) call _setActiveWin;
        },
        "ResultFormated", "KeyDown", {

        },
        "HistoryList", "LBDblClick", {
            call _execFromHistory
        },
        ["ResultFormated", "HistoryList"], "KeyDown", { // args: Control, KeyCodes, Shift, Ctrl, Alt
            if(arg(3)) then { // Ctrl
                if(arg(1) in [DIK_C, DIK_INSERT])then{
                    arg(0) call _copyFromListBoxToClipboard;
                };
            };
            if(arg(0) == _ctrlHistoryList) then { switch (arg(1)) do {
                case DIK_INSERT: { call _execFromHistory; };
                case DIK_DELETE: { call _delFromHistory; };
            }};
        },
        ["Demo", "Help"], "HTMLLink", {
            private ["_arr", "_arrCopy", "_colonIndex", "_linkPrefix", "_linkData"];
            _arr = toArray str parseText arg(1);
            _arrCopy = +_arr;
            _colonIndex = _arr find 58; // 58 == code of char ":"
            if(_colonIndex < 0)exitWith{};
            _arrCopy set [_colonIndex, 0];
            _linkPrefix = toString(_arrCopy);
            for "_i" from 0 to _colonIndex do {
                _arr set [_i, 0]
            };
            _linkData = toString(_arr - [0]);
            switch (_linkPrefix) do {
                case "sqf": {
                    _ctrlInputText ctrlSetText _linkData;
                    _linkData call {
                        if( [_this call _execExpression] call _displayValue ) then {
                            0 call _setActiveWin;
                        };
                        _this call _addToHistory;
                    };
                };
                case "src": {
                    arg(0) htmlLoad _linkData;
                };
            };
        }
    ];

    _constructor = {
        // data & functions
        // window management
        _windowStruct = [
            _ctrlResultFormated,
            _ctrlResultText,
            _ctrlHistoryList,
            _ctrlDemoFrame,
            _ctrlHelpFrame
        ];
        _setActiveWin = {
            private "_item";
            for "_i" from 0 to count _windowStruct - 1 do {
                _item = _windowStruct select _i;
                (_i == _this) call {
                    _item ctrlShow _this;
                    if(_this) then { ctrlSetFocus _item };
                };
            }
        };
        _getActiveWinSibling = {
            ((
                for "_i" from 0 to count _windowStruct - 1 do {
                    if( ctrlShown (_windowStruct select _i) )exitWith{ _i }; 0
                }
            ) + _this) % count _windowStruct
        };
        _updateHistory = {
            lbClear _ctrlHistoryList;
            { _ctrlHistoryList lbAdd _x } foreach _commandsHistory;
        };
        _delFromHistory = {
            _commandsHistory = _commandsHistory - [_ctrlHistoryList lbText lbCurSel _ctrlHistoryList];
            call _updateHistory;
            _ctrlHistoryList lbSetCurSel ((lbSize _ctrlHistoryList - 1) min (lbCurSel _ctrlHistoryList));
        };
        _addToHistory = {
            {
                if(_x != "")then{
                    _commandsHistory = _commandsHistory - [_x];
                    push(_commandsHistory, _x);
                    call _updateHistory;
                }
            } foreach (
                if(typeName _this == "ARRAY") then {_this} else {
                    [(if(typeName _this != "STRING") then { "" } else { _this })]
                }
            );
        };
        _execFromHistory = {
            private "_text";
            _text = _ctrlHistoryList lbText lbCurSel _ctrlHistoryList;
            _ctrlInputText ctrlSetText _text;
            [_text call _execExpression] call _displayValue;
            ctrlText _ctrlInputText call _addToHistory;
        };
        _copyFromListBoxToClipboard = {
            private ["_listBox", "_currentLine", "_currentDepth", "_result", "_char0D0A", "_buffer"];
            _listBox = _this;
            _currentLine = lbCurSel _listBox;
            _currentDepth = _resultCacheDepth select _currentLine;
            _buffer = [];
            _char0D0A = toString [13,10];
            for "_i" from _currentLine to count _resultCacheDepth - 1 do {
                if( (_i > _currentLine) && (_resultCacheDepth select _i) <= _currentDepth )exitWith{
                    if( _currentLine + 1 < _i )then{ push(_buffer, _resultCacheText select _i) };
                };
                push(_buffer, _resultCacheText select _i);
            };
            _result = [_buffer, _char0D0A] call _funcJoinString;
            copyToClipboard _result;
            _ctrlResultText ctrlSetText _result;
        };
        _funcJoinString = {
            //
            // Fast string concatenation,
            //
            private ["_list", "_char", "_size", "_subsize", "_oversize", "_j"];

            _list = arg(0);
            _char = arg(1);

            if( count _list < 1 ) exitwith {""};

            while { count _list > 1 } do {
                _size = count _list / 2;
                _subsize = floor _size;
                _oversize = ceil _size;
                _j = 0;
                for "_i" from 0 to _subsize - 1 do {
                    _list set [_i, (_list select _j) + _char + (_list select (_j+1))];
                    _j = _j + 2;
                };
                if( _subsize != _oversize )then { // to add a tail
                    _list set [_j/2, _list select _j];
                };
                _list resize _oversize;
            };

            _list select 0;
        };
        _applySettingsFromFile = {
            0 call {
                private "_regHK";
                _regHK = {
                    private ["_keyName", "_keyCode"];
                    _keyName = arg(0);
                    _keyCode = arg(1);
                    if(parseNumber format["%1", _keyCode] != 0)then{
                        (_hotKeysRegister find _keyName) call {
                            if(_this > 0)then{
                                _hotKeysRegister set [_this+1, _keyCode];
                            }
                        };
                    };
                };
                _this = ((preprocessFile "SQFCalculator\settings") call {
                    if(_this != "")then{
                        private _privateNames; // to safe our scope
                        private ["_myHistory", "_HKInput", "_HKDisplay", "_HKDisplay2", "_HKHistory", "_HKDemo", "_HKHelp", "_HKLeft", "_HKRight"]; // avialable parameters
                        call compile _this;
                        [ _myHistory, [
                            ["HKInput", _HKInput], ["HKDisplay", _HKDisplay], ["HKDisplay2", _HKDisplay2], ["HKHistory", _HKHistory],
                            ["HKDemo", _HKDemo], ["HKHelp", _HKHelp], ["HKLeft", _HKLeft], ["HKRight", _HKRight]
                        ]];
                    };
                });
                (_this select 0) call {
                    if(typeName _this == "ARRAY")then{
                        _this call _addToHistory;
                    };
                };
                { _x call _regHK } foreach (_this select 1);
            };
        };
        // sqf expression executor
        _execExpression = {
            private _privateNames; // to safe our scope
            call compile _this; // exec any code
        };
        _displayValue = {
            private [
                "_value",
                "_outstr",
                "_indents",
                "_depth",
                "_writeLine",
                "_traverseConfigTree",
                "_traverseTree",
                "_isConfigContext",
                "_getComma",
                "_getCommaAfterBracket"
            ];

            _value = arg(0);

            lbClear _ctrlResultFormated;

            _ctrlResultText ctrlSetText format["%1", _value];

            _resultCacheText resize 0;
            _resultCacheDepth resize 0;

            _outstr = "";
            _indents = [""];
            _depth = 0;
            _writeLine = {
                private ["_i", "_text"];
                if(_depth >= count _indents) then {
                    _indents set [_depth, (_indents select _depth-1) + "    "];
                };
                _text = (_indents select _depth) + _this;
                _i = _ctrlResultFormated lbAdd _text;
                _resultCacheText set [_i, _text];
                _resultCacheDepth set [_i, _depth];
            };
            _traverseConfigTree = {
                private "_confName";
                _confName = configName _this;
                if( isText _this ) exitWith { _confName + " = " + str getText _this + ";" call _writeLine };
                if( isNumber _this ) exitWith { _confName + " = " + str getNumber _this + ";" call _writeLine };
                if( isArray _this ) exitWith {
                    getArray _this call {
                        if(count _this == 0) then {
                            _confName + "[] = {}" call _writeLine;
                        } else {
                            _confName + "[] =" call _writeLine;
                            _this call _traverseTree;
                        }
                    }
                };
                if( isClass _this ) exitWith {
                    "class " + _confName + (
                        configName inheritsFrom _this call { if(_this == "")then{""}else{" : " + _this} }
                    ) + " {" call _writeLine;

                    _depth = _depth + 1;
                    for "_i" from 0 to count _this - 1 do {
                        _this select _i call _traverseConfigTree
                    };
                    _depth = _depth - 1;

                    "};" call _writeLine;
                };
            };
            ///////////////////////////////////////////////
            _commaNeed = false;
            _isConfigContext = false;
            _getComma = { ["", ","] select _commaNeed };
            _getCommaAfterBracket = { [["", ";"] select _isConfigContext, ","] select _commaNeed };
            _traverseTree = {
                switch (toUpper typeName _this) do {
                    case "ARRAY" : {
                        private ["_str", "_arr", "_to", "_lBracket", "_rBracket"];
                        if( _isConfigContext )then{
                            _lBracket = "{";
                            _rBracket = "}";
                        }else{
                            _lBracket = "[";
                            _rBracket = "]";
                        };
                        _lBracket call _writeLine;
                        _depth = _depth + 1;
                        _to = count _this - 1;
                        for "_i" from 0 to _to do {
                            private "_commaNeed";
                            _commaNeed = _i != _to;
                            _this select _i call _traverseTree;
                        };
                        _depth = _depth - 1;
                        _rBracket + call _getCommaAfterBracket call _writeLine;

                    };
                    case "CONFIG" : {
                        _isConfigContext = true;
                        _this call _traverseConfigTree;
                        _isConfigContext = false;
                    };
                    default {
                        (str _this) + call _getComma call _writeLine
                    };
                };
            };

            _ctrlResultFormated lbSetCurSel 0;

            if(isNil "_value")then{ false } else {
                _value call _traverseTree;
                true;
            };
        };

        _privateNames = _private; // save private names

        // initialization
        _accTime = accTime;
        _soundVolume = soundVolume;
        setAccTime 0;
        0 fadeSound 0;


        _resultCacheText = [];
        _resultCacheDepth = [];

        0 call _setActiveWin;

        if( isNil "RLS_SQFConsole_History" )then{
            RLS_SQFConsole_History = [];
        };

        _hotKeysRegister = [
            "HKInput", DIK_1, "HKDisplay", DIK_2, "HKDisplay2", DIK_3, "HKHistory", DIK_4,
            "HKDemo", DIK_5, "HKHelp", DIK_6, "HKLeft", DIK_LEFT, "HKRight", DIK_RIGHT
        ];

        _commandsHistory = RLS_SQFConsole_History;
        call _applySettingsFromFile;

        (missionConfigFile >> "RscSqfCalcDemo") call {
            if(!isClass _this)exitwith{};
            private "_pos";
            _pos = ctrlPosition _ctrlDemo;
            _pos set [3, getNumber(_this >> "htmlControlHeight")];
            _ctrlDemo ctrlSetPosition _pos;
            _ctrlDemo ctrlCommit 0;
            _ctrlDemo htmlLoad getText(_this >> "htmlfile");
        };

        ctrlSetFocus _ctrlInputText;
    };

    _destructor = {
        setAccTime _accTime;
        0 fadeSound _soundVolume;
        call { RLS_SQFConsole_History = _commandsHistory; }
    };

} call _funcCreateDialog);

