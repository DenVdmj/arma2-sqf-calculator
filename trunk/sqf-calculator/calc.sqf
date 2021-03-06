// sqf
// Веселый Калькулятор - Calculador Alegre
// Copyright (c) 2009-2010 Denis Usenko (DenVdmj@gmail.com)
// MIT-style license

#include "\sqf-calculator\common.hpp"
#include "\sqf-calculator\dik-codes.hpp"
#include "\sqf-calculator\gui.sqf"

#define __setHistroy(history) ((history)__uiSet(History))
#define __getHistroy __uiGet(History)

#define __processListRef VDMJ_SQFConsole_processListRef
#define __hudFlag VDMJ_SQFConsole_HUD

// Display's KeyDown handler (args: Control, KeyCodes, Shift, Ctrl, Alt)
// Only for OnKeyDown and OnKeyUp handlers!
#define __argSelf arg(0)
#define __argKeyCode arg(1)
#define __argShiftPressed arg(2)
#define __argCtrlPressed arg(3)
#define __argAltPressed arg(4)

private "_self";
_self = _this;

{
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
        "_configOutputMode",
        "_maxTimeout",
        // function
        "_updateHistory",
        "_updateProcessList",
        "_delFromHistory",
        "_addToHistory",
        "_execFromHistory",
        "_setFromHistory",
        "_setActiveWin",
        "_getActiveWinSibling",
        "_execExpression",
        "_addProcess",
        "_killProcess",
        "_displayValue",
        "_joinString",
        "_copyFromListBoxToClipboard",
        "_moveCurSelToOpeningBracket",
        "_moveCurSelToClosingBracket",
        "_applySettingsFromFile",
        "_removeItemsFromArray"
    ];

    _handlers = [
        _rsc, "KeyDown", {  // Display's KeyDown handler (args: Control, KeyCodes, Shift, Ctrl, Alt)
            if (__argAltPressed) then {
                private "_keyCode";
                _keyCode = __argKeyCode;
                _hotKeysRegister find _keyCode call {
                    if (_this > 0) then {
                        switch (_hotKeysRegister select (_this - 1)) do {
                            case "HKLeft" :  { - 1 call _getActiveWinSibling call _setActiveWin };
                            case "HKRight" : { + 1 call _getActiveWinSibling call _setActiveWin };
                            case "HKInput" :     { ctrlSetFocus _ctrlInputText };
                            case "HKDisplay" :   { 0 call _setActiveWin };
                            case "HKDisplay2" :  { 1 call _setActiveWin };
                            case "HKHistory" :   { 2 call _setActiveWin };
                            case "HKProcesses" : { 3 call _setActiveWin };
                            case "HKDemo" :      { 4 call _setActiveWin };
                            case "HKHelp" :      { 5 call _setActiveWin };
                        };
                    };
                };
            };
        },
        "InputText", "KeyDown", {
            if (__argKeyCode == DIK_RETURN) then {
                if (__argCtrlPressed) then {
                    ctrlText _ctrlInputText call _addProcess;
                } else {
                    ctrlText _ctrlInputText call _execExpression;
                };
            };
        },
        "SelectWin", "ToolBoxSelChanged", {
            __argKeyCode call _setActiveWin;
        },
        "WatchButton", "ButtonClick", {
            ctrlText _ctrlInputText call _addProcess;
        },
        "ConfigOutputModeButton", "ButtonClick", {
            _self = __argSelf;
            _selfConf = _self call _dsplGetConfByCtrl;
            _texts = getArray (_selfConf >> "texts");
            _index = (((_texts find ctrlText _self) + 1) % count _texts);
            _self ctrlSetText (_texts select _index);
            _configOutputMode = _index;
        },
        "ResultFormated", "KeyDown", {
            if (__argCtrlPressed) exitwith {
                if (
                    __argKeyCode == DIK_C ||
                    __argKeyCode == DIK_INSERT
                ) exitwith {
                    __argSelf call _copyFromListBoxToClipboard
                };
            };
            if (__argAltPressed) exitwith {
                switch (__argKeyCode) do {
                    case DIK_LBRACKET: { __argSelf call _moveCurSelToOpeningBracket };
                    case DIK_RBRACKET: { __argSelf call _moveCurSelToClosingBracket };
                };
            };
        },
        "HistoryList", "KeyDown", {
            if (__argCtrlPressed) exitwith {
                if (__argKeyCode == DIK_C || __argKeyCode == DIK_INSERT) exitwith {
                    copyToClipboard (__argSelf lbText lbCurSel __argSelf);
                };
            };
            if (__argShiftPressed) exitwith {};
            if (__argAltPressed) exitwith {};
            switch (__argKeyCode) do {
                case DIK_INSERT: { call _setFromHistory };
                case DIK_DELETE: { call _delFromHistory };
                case DIK_RETURN: { call _execFromHistory };
            };
        },
        "HistoryList", "lbDblClick", {
            call _execFromHistory
        },
        "ProcessList", "KeyDown", {
            if (__argKeyCode == DIK_DELETE) then {
                lbCurSel _ctrlProcessList call _killProcess;
            };
        },
        ["Demo", "Help"], "HTMLLink", {
            private ["_arr", "_arrCopy", "_colonIndex", "_linkPrefix", "_linkData"];
            _arr = toArray str parseText arg(1);
            _arrCopy = +_arr;
            _colonIndex = _arr find 58; // 58 == code of char ":"
            if (_colonIndex < 0) exitwith {};
            _arrCopy set [_colonIndex, 0];
            _linkPrefix = toString(_arrCopy);
            for "_i" from 0 to _colonIndex do {
                _arr set [_i, 0]
            };
            _linkData = toString(_arr - [0]);
            switch (_linkPrefix) do {
                case "sqf": {
                    _ctrlInputText ctrlSetText _linkData;
                    _linkData call _execExpression;
                };
                case "src": {
                    __argSelf htmlLoad _linkData;
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
            _ctrlProcessList,
            _ctrlDemoFrame,
            _ctrlHelpFrame
        ];
        _setActiveWin = {
            private "_item";
            for "_i" from 0 to count _windowStruct - 1 do {
                _item = _windowStruct select _i;
                (_i == _this) call {
                    _item ctrlShow _this;
                    if (_this) then {
                        ctrlSetFocus _item;
                    };
                };
            }
        };
        _getActiveWinSibling = {
            ((
                for "_i" from 0 to count _windowStruct - 1 do {
                    if (ctrlShown (_windowStruct select _i)) exitwith { _i }; 0
                }
            ) + _this) % count _windowStruct
        };
        _setCustomView = {
            private ["_d", "_c"];
            _ctrlMainback ctrlSetText "#(argb,8,8,3)color(0,0,0,0.8)";
            _ctrlMainback ctrlSetPosition [0, -.01, 1, 1.02];
            _ctrlMainback ctrlCommit 0;
            {
                _x ctrlSetFont "vdmj_PragmataPro"; // "vdmj_Consolas"
                _x ctrlSetFontHeight .028
            } forEach [
                _ctrlInputText,
                _ctrlSelectWin,
                _ctrlConfigOutputModeButton,
                _ctrlWatchButton,
                _ctrlResultFormated,
                _ctrlResultText,
                _ctrlHistoryList,
                _ctrlProcessList,
                _ctrlDemoFrame,
                _ctrlDemo,
                _ctrlHelpFrame,
                _ctrlHelp
            ];
        };
        _updateHistory = {
            lbClear _ctrlHistoryList;
            { _ctrlHistoryList lbAdd _x } foreach _commandsHistory;
        };
        _delFromHistory = {
            [_commandsHistory, [_ctrlHistoryList lbText lbCurSel _ctrlHistoryList]] call _removeItemsFromArray;
            call _updateHistory;
            _ctrlHistoryList lbSetCurSel ((lbSize _ctrlHistoryList - 1) min (lbCurSel _ctrlHistoryList));
        };
        _addToHistory = {
            private "_toString";
            _toString = {
                if (typeName _this == "STRING") exitwith { _this };
                if (typeName _this == "CODE") exitwith {
                    private "_res";
                    _res = [];
                    _chars = toArray str _this;
                    for "_i" from 1 to count _chars-2 do {
                        __push(_res, _chars select _i);
                    };
                    toString _res;
                };
                "";
            };
            {
                _x = _x call _toString;
                if (_x != "") then {
                    [_commandsHistory, [_x]] call _removeItemsFromArray;
                    __push(_commandsHistory, _x);
                    call _updateHistory;
                }
            } foreach (
                if (typeName _this == "ARRAY") then { _this } else { [_this] }
            );
        };
        _execFromHistory = {
            call _setFromHistory call _execExpression;
        };
        _setFromHistory = {
            private "_text";
            ctrlSetFocus _ctrlInputText;
            _text = _ctrlHistoryList lbText lbCurSel _ctrlHistoryList;
            _ctrlInputText ctrlSetText _text;
            _text;
        };
        _removeItemsFromArray = {
            private ["_array", "_items", "_offset", "_item"];
            _array = arg(0);
            _items = arg(1);
            _offset = 0;
            for "_i" from 0 to count _array do {
                _item = _array select _i;
                if (_offset > 0) then {
                    _array set [_i - _offset, _item]
                };
                if (_item in _items) then {
                    _offset = _offset + 1;
                };
            };
            _array;
        };
        _copyFromListBoxToClipboard = {
            private ["_listBox", "_currentLine", "_currentDepth", "_result", "_char0D0A", "_buffer"];
            _listBox = _this;
            _currentLine = lbCurSel _listBox;
            _currentDepth = _resultCacheDepth select _currentLine;
            _buffer = [];
            _char0D0A = toString [13,10];
            for "_i" from _currentLine to count _resultCacheDepth - 1 do {
                if ((_i > _currentLine) && (_resultCacheDepth select _i) <= _currentDepth) exitwith {
                    if (_currentLine + 1 < _i) then { __push(_buffer, _resultCacheText select _i) };
                };
                __push(_buffer, _resultCacheText select _i);
            };
            _result = [_buffer, _char0D0A] call _joinString;
            copyToClipboard _result;
            _ctrlResultText ctrlSetText _result;
        };

        _moveCurSelToOpeningBracket = {
            private ["_listBox", "_currentLine", "_currentDepth"];
            _listBox = _this;
            _currentLine = lbCurSel _listBox;
            _currentDepth = _resultCacheDepth select _currentLine;
            for "_i" from _currentLine to 0 step -1 do {
                if ((_i < _currentLine) && (_resultCacheDepth select _i) <= _currentDepth) exitwith {
                    _listBox lbSetCurSel _i;
                };
            };
        };

        _moveCurSelToClosingBracket = {
            private ["_listBox", "_currentLine", "_currentDepth"];
            _listBox = _this;
            _currentLine = lbCurSel _listBox;
            _currentDepth = _resultCacheDepth select _currentLine;
            for "_i" from _currentLine to count _resultCacheDepth - 1 do {
                if ((_i > _currentLine) && (_resultCacheDepth select _i) <= _currentDepth) exitwith {
                    _listBox lbSetCurSel _i;
                };
            };
        };

        _addProcess = {
            private "_code";
            _code = compile _this;
            if (! isNil { call _code }) then {
                if (isNil '__hudFlag') then {
                    __hudFlag = true;
                    78934 cutRsc ["RscVdmjSqfCalculatorHUD", "PLAIN"];
                };
                __push((__processListRef select 0), compile _this);
                call _updateProcessList;
                _this call _addToHistory;
            };
        };

        _killProcess = {
            private ["_processList"];
            _processList = __processListRef select 0;
            _processList set [_this, {}];
            __processListRef set [0, _processList - [{}]];
            call _updateProcessList;
        };

        _updateProcessList = {
            lbClear _ctrlProcessList;
            { _ctrlProcessList lbAdd str _x } foreach (__processListRef select 0);
        };

        _joinString = {
            //
            // Fast string concatenation,
            //
            private ["_list", "_char", "_size", "_subsize", "_oversize", "_j"];

            _list = arg(0);
            _char = arg(1);

            if (count _list < 1) exitwith {""};

            for "" from 1 to ceil(__log2(count _list)) do {
                _size = count _list / 2;
                _subsize = floor _size;
                _oversize = ceil _size;
                _j = 0;
                for "_i" from 0 to _subsize - 1 do {
                    _list set [_i, (_list select _j) + _char + (_list select (_j+1))];
                    _j = _j + 2;
                };
                if (_subsize != _oversize) then { // to add a tail
                    _list set [_j/2, _list select _j];
                };
                _list resize _oversize;
            };

            _list select 0;
        };
        _applySettingsFromFile = {
            private "_apply";
            _apply = {
                (_this call {
                    if (_this != "") then {
                        private _privateNames; // to safe our scope
                        private [ // avialable parameters
                            "_myHistory", "_maxTimeout",
                            "_HKOpenConsole", "_HKInput", "_HKDisplay", "_HKDisplay2", "_HKHistory",
                            "_HKProcesses", "_HKDemo", "_HKHelp", "_HKLeft", "_HKRight"
                        ];
                        call compile _this;
                        [
                            _myHistory, _maxTimeout,
                            [
                                ["HKOpenConsole", _HKOpenConsole],
                                ["HKInput", _HKInput],
                                ["HKDisplay", _HKDisplay],
                                ["HKDisplay2", _HKDisplay2],
                                ["HKHistory", _HKHistory],
                                ["HKDemo", _HKDemo],
                                ["HKHelp", _HKHelp],
                                ["HKLeft", _HKLeft],
                                ["HKRight", _HKRight]
                            ]
                        ];
                    };
                }) call {
                    private "_regHK";
                    _regHK = {
                        private ["_keyName", "_keyCode", "_index"];
                        _keyName = arg(0);
                        _keyCode = arg(1);
                        if (parseNumber format ["%1", _keyCode] != 0) then {
                            _index = _hotKeysRegister find _keyName;
                            if (_index > 0) then {
                                _hotKeysRegister set [_index+1, _keyCode];
                            };
                            if (_keyName == "HKOpenConsole") then {
                                parsingNamespace setVariable ['/sqf-calculator/HKOpenConsole', _keyCode];
                            };
                        };
                    };
                    arg(0) call { if (typeName _this == "ARRAY") then { _this call _addToHistory; }; };
                    arg(1) call { if (typeName _this == "SCALAR") then { _maxTimeout = _this; }; };
                    {
                        _x call _regHK
                    } foreach arg(2);
                };
            };
            (preprocessFile "\userconfig\sqf-calculator\settings") call _apply;
        };
        // sqf expression executor
        _execExpression = {
            if (
                [_this call {
                    private _privateNames; // to safe our scope
                    call compile _this; // exec any code
                }] call _displayValue
            ) then {
                0 call _setActiveWin;
                ctrlSetFocus _ctrlInputText;
            };
            _this call _addToHistory;
        };
        _displayValue = {
            private [
                "_value", "_indents", "_depth",
                "_writeLine", "_escapeString",
                "_collectInheritedProperties",
                "_traverseConfigTree", "_traverseTree",
                "_isConfigContext", "_commaAfterBracket",
                "_getComma", "_timeout"
            ];

            _value = arg(0);
            _timeout = diag_tickTime + _maxTimeout;
            scopeName "_displayValueScope";

            lbClear _ctrlResultFormated;

            _ctrlResultText ctrlSetText format["%1", _value];

            _resultCacheText resize 0;
            _resultCacheDepth resize 0;

            _indents = [""];
            _depth = 0;

            _writeLine = {
                private ["_i", "_text"];
                // если отступа нужной длины еще нет, создать новый
                if (_depth >= count _indents) then {
                    _indents set [_depth, (_indents select _depth-1) + "    "];
                };
                _text = (_indents select _depth) + _this;
                _i = _ctrlResultFormated lbAdd _text;
                _resultCacheText set [_i, _text];
                _resultCacheDepth set [_i, _depth];
                if (diag_tickTime > _timeout) then {
                    breakOut "_displayValueScope";
                };
            };

            _escapeString = (
                // swither ====
                if (true) then {{
                    private ["_source", "_target", "_start", "_charCode"];
                    _source = toArray _this;
                    _start = _source find 34;
                    if (_start > 0) then {
                        _target = +_source;
                        _target resize _start;
                        for "_i" from _start to count _source - 1 do {
                            _charCode = _source select _i;
                            __push(_target, _charCode);
                            if (_charCode == 34) then {
                                __push(_target, _charCode);
                            };
                        };
                        str toString _target;
                    } else {
                        str _this;
                    };
                }} else {{
                    str _this
                }}
            );

            _collectInheritedProperties = {
                private [
                    "_config", "_properties", "_propertiesLC",
                    "_property", "_propertyLC"
                ];
                _config = _this;
                _properties = [];
                _propertiesLC = [];
                while {
                    for "_i" from 0 to count _config - 1 do {
                        _property = _config select _i;
                        _propertyLC = toLower configName _property;
                        if!(_propertyLC in _propertiesLC) then {
                            __push(_properties, _property);
                            __push(_propertiesLC, _propertyLC);
                        };
                    };
                    configName _config != "";
                } do {
                    _config = inheritsFrom _config;
                };
                _properties;
            };

            _traverseConfigTree = {
                private "_confName";
                _confName = configName _this;
                if (_configOutputMode == 2) exitwith {
                    "config entry: {" + (str _this) + "}" call _traverseTree
                };
                if (isText _this) exitwith {
                    _confName + " = " + (getText _this call _escapeString) + ";" call _writeLine
                };
                if (isNumber _this) exitwith {
                    _confName + " = " + str getNumber _this + ";" call _writeLine
                };
                if (isArray _this) exitwith {
                    getArray _this call {
                        if (count _this == 0) then {
                            _confName + "[] = {};" call _writeLine;
                        } else {
                            _commaAfterBracket = ";";
                            _confName + "[] = {" call _writeLine;
                            _this call _traverseTree;
                            _commaAfterBracket = "";
                        };
                    };
                };
                if (isClass _this) exitwith {
                    "class " + _confName + (
                        configName inheritsFrom _this call {
                            if (_this == "") then { "" } else { " : " + _this }
                        }
                    ) + " {" call _writeLine;

                    // swither ====
                    if (_configOutputMode == 0) then {
                        _this = _this call _collectInheritedProperties;
                    };

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
            _commaAfterBracket = "";
            _getComma = { [_commaAfterBracket, ","] select _commaNeed };

            _traverseTree = {
                switch (toUpper typeName _this) do {
                    case "ARRAY" : {
                        private ["_str", "_arr", "_to", "_lBracket", "_rBracket"];
                        if (_isConfigContext) then {
                            _lBracket = "{";
                            _rBracket = "}";
                        } else {
                            _lBracket = "[";
                            _rBracket = "]";
                        };
                        if (_commaAfterBracket == "") then {
                            _lBracket call _writeLine;
                        };
                        _depth = _depth + 1;
                        _to = count _this - 1;

                        if (
                            if (count toArray str _this < 90) then {
                                {
                                    if (typeName _x in ["ARRAY", "CONFIG"]) exitwith {false}; true
                                } foreach _this;
                            } else {
                                false
                            }
                        ) then {
                            private "_list";
                            _list = [];
                            {
                                __push(_list, if (typeName _x == "STRING") then { _x call _escapeString } else { str _x })
                            } foreach _this;
                            ([_list, ", "] call _joinString) call _writeLine;
                        } else {
                            for "_i" from 0 to _to do {
                                private ["_commaNeed", "_commaAfterBracket"];
                                _commaAfterBracket = "";
                                _commaNeed = _i != _to;
                                _this select _i call _traverseTree;
                            };
                        };
                        _depth = _depth - 1;
                        _rBracket + call _getComma call _writeLine;
                    };
                    case "CONFIG" : {
                        _isConfigContext = true;
                        _this call _traverseConfigTree;
                        _isConfigContext = false;
                    };
                    case "STRING" : {
                        (_this call _escapeString) + call _getComma call _writeLine;
                    };
                    default {
                        (str _this) + call _getComma call _writeLine;
                    };
                };
            };

            _ctrlResultFormated lbSetCurSel 0;

            if (!isNil "_value") then {
                _value call _traverseTree;
                true;
            };
        };

        _privateNames = _private; // save private names

        call _setCustomView;

        // initialization
        _accTime = accTime;
        _soundVolume = soundVolume;
        setAccTime 0;
        0 fadeSound 0;
        "DynamicBlur" ppEffectEnable false;

        _configOutputMode = 1;

        _resultCacheText = [];
        _resultCacheDepth = [];

        0 call _setActiveWin;

        _hotKeysRegister = [
            "HKInput", DIK_1,
            "HKDisplay", DIK_2,
            "HKDisplay2", DIK_3,
            "HKHistory", DIK_4,
            "HKProcesses", DIK_5,
            "HKDemo", DIK_6,
            "HKHelp", DIK_7,
            "HKLeft", DIK_LEFT,
            "HKRight", DIK_RIGHT
        ];

        _maxTimeout = 20;

        if (isNil {__getHistroy}) then {
            __setHistroy([]);
        };
        _commandsHistory = __getHistroy;
        call _applySettingsFromFile;

        if (isNil '__processListRef') then {
            __processListRef = [[]];
        };

        call _updateProcessList;

        (missionConfigFile >> "RscSqfCalcDemo") call {
            if (!isClass _this) exitwith {};
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
        if (accTime == 0) then {
            setAccTime _accTime;
        };
        0 fadeSound _soundVolume;
        __setHistroy(_commandsHistory);
    };

} invoke(CreateDialog);

showCommandingMenu "";
true;
