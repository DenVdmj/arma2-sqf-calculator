[[Russian version](http://code.google.com/p/arma2-sqf-calculator/wiki/QuicklyStartRu)]

## Script console “Calculator” for ARMA2 Game ##
### Quickly start ###
[Download now](http://code.google.com/p/arma2-sqf-calculator/downloads/list) the latest version of the console.
Addon _“sqf-calculator.pbo”_ should be located in the folder _<X:path\to\ArmA_<s></s>2Folder\@\sqf-calculator\Addons\sqf-calculator.pbo"_, and folder_“\userconfig\sqf-calculator\”_in folder_“X:path\to\ArmA<s></s>2Folder\”_._

This command line used to start the game:
```
    X:path\to\ArmA2Folder\arma2oa.exe -nosplash -window -showScriptErrors -mod=@\sqf-calculator
```
Now go to the mission editor, open any mission, go to preview, press ESC and in the pause menu, press tilde (~).
Moreover, you can call console from the following locations: the root display, the editor map, map in the game, setup menu of objects in the editor.

### Usage ###
This very simple console is able to execute the expression and display the result in digestible format.

To execute code type or paste it in the input field and press _“Enter”_.
Formatted result will be displayed in the window _“Results”_, and you can edit it in the window _“Buffer”_.

Try these examples:

```
    [weapons player, magazines player]
    configFile >> "CfgVehicles" >> typeOf vehicle player
    [getpos player nearObjects 100, configFile >> "CfgWeapons" >> "Default"]
```

Hot keys _"Ctrl+C"_ or _"Ctrl+Insert"_ in the window _“Result”_ puts the current line of result  on the clipboard.

If the current line opens the some container, ie, it is opening bracket of an array or a config class name, then, in this case will be copied to the entire container.

All executed expressions are stored in the history. Double-click or keystroke _“Insert”_ on the item of history puts the selected line in the input field and executes it. Unwanted items of _“History”_ you can delete by pressing _“Delete”_.

Button “Watch” creates watcher screen for your code or variables (will be displayed during the game in the top left corner). Unnecessary watchers can be killed in the “Processes”.

Button "As Is config" switches the display mode config:
  * As Is config - is shown as is, without the inherited properties;
  * Folded config - displays only the path in the config;
  * Full config - is displayed with all inherited properties.

Console hot keys:

|Enter|execute sqf-expression|
|:----|:---------------------|
|Ctrl+Enter|create watcher of sqf-expression|
|Ctrl+C, Ctrl+Insert|copy line or block to clipboard|
|Alt+]|jump to the end of class or array|
|Alt+[|jump to the start of class or array|
|Alt+1|switch to text-input|
|Alt+2|switch to “Result”|
|Alt+3|switch to “Edit”|
|Alt+4|switch to “History”|
|Alt+5|switch to “Process”|
|Alt+6|switch to “Demo”|
|Alt+7|switch to “Help”|
|Alt+Left Arrow|switch focus to left neighbour|
|Alt+Right Arrow|switch focus to right neighbour|

You may create a initialization file “\userconfig\sqf-calculator\settings” ([DIK help](http://community.bistudio.com/wiki/DIK_KeyCodes)):

```
    // File “arma2folder\userconfig\sqf-calculator\settings”
    // Persistent history item, frequently used sqf-expression, snippets
    _myHistory = [
        'weapons player',
        'magazines player',
        'configFile >> "CfgVehicles" >> typeOf cursorTarget',
        'call compile preprocessFileLineNumbers ".sqf"'
    ];

    //
    // The maximum time allowed for execution of the expression
    // For example, the total time for output full game config may be 20 seconds and more.
    // At the latest patches ArmA2, well, sooo much time: ((
    //

    _maxTimeout = 20;

    //
    // Codes keyboard shortcuts, with clamped alt
    //

    //  _HKOpenConsole = 0x3B; // F1 key
    //  _HKOpenConsole = 0x3C; // F2 key
    //  _HKOpenConsole = 0x29; // tilda key
    //  _HKOpenConsole = 0x52; // grey 0
    //  _HKInput = 2;
    //  _HKDisplay = 3;
    //  _HKDisplay2 = 4;
    //  _HKHistory = 0x23;
    //  _HKProcesses = 0x24
    //  _HKDemo = 0x20;
    //  _HKHelp = 0x3B;
    //  _HKLeft =
    //  _HKRight =

    //
    // Casual shortcut
    //

    cfg  = configFile;
    cfga = configFile >> "CfgAmmo";
    cfgm = configFile >> "CfgMagazines";
    cfgw = configFile >> "CfgWeapons";
    cfgv = configFile >> "CfgVehicles";
    mcfg = missionConfigFile;
    ccfg = campaignConfigFile;

```