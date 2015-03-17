[[English version](http://code.google.com/p/arma2-sqf-calculator/wiki/QuicklyStart)]

## Скрипт-консоль «Калькулятор» для игры ARMA2 ##
### Быстрый старт ###
#### Установка ####
[Скачайте](http://code.google.com/p/arma2-sqf-calculator/downloads/list) последнюю версию консоли.
Поместите папку _«sqf-calculator»_ в папку _«X:path\to\ArmA_<s></s>2Folder\@\»_, а папку настроек_«\userconfig\sqf-calculator\»_в папку игры_«X:path\to\ArmA<s></s>2Folder\»_._

#### Запуск ####
Запустите игру следующей командной строкой:
```
    X:path\to\ArmA2Folder\arma2oa.exe -nosplash -window -showScriptErrors -mod=@\sqf-calculator
```
Теперь, чтобы вызвать консоль, зайдите в редактор игры, откройте любую миссию, перейдите в режим предпросмотра, нажатием ESC выйдите в меню паузы и нажмите тильду (~). Вы можете вызывать консоль и в других  местах: в корневом меню игры, в синглмиссиях и кампании (в меню паузы), на карте в обычном и 3D редакторе, в меню установки юнитов, триггеров, групп, и в других меню в редакторе.

#### Использование ####

Итак Вы запустили консоль, теперь попробуйте выполнить такое примеры:
```
    [weapons player, magazines player]
    configFile >> "CfgVehicles" >> typeOf vehicle player
    [getpos player nearObjects 100, configFile >> "CfgWeapons" >> "Default"]
```

Результат вычисления этих выражений будет отображен в окнах «Результат» и «Буфер», кроме того, в окне «Буфер» Вы сможете отредактировать текст результата, вырезать часть в буфер обмена, и т.д.


Горячие комбинации "Ctrl+C" или "Ctrl+Insert" в окне «Результат» копируют текущую строку результата в буфер обмена (а также в окно «Буфер», для возможности редактирования). Если копируемая строка открывает контейнер (открывающая скобка массива или имя класса конфига),
то в буфер обмена будет помещено содержимое всего это контейнера (массив или раздел конфига).


Каждое выполненное выражение запоминается в истории, двойной клик или нажатие клавиши «Enter» на пункте списка в окне «История» помещает
выбранное выражение в поле ввода и выполняет его. Клавиша «Insert» копирует текущий пункт «истории» в поле ввода (без выполнения).
Ненужные пункты «истории» можно удалять клавишей «Delete».


Кнопка «Следить» добавляет выражение для наблюдения (будут отображаться в процессе игры в верхнем левом углу),
ненужные watcher'ы можно убить в окне «Процессы».


Кнопка-переключатель "Стандартный конфиг" переключает режим отображения конфига:
  * Стандартный конфиг -- классы показываются как есть, без наследуемых свойств.
  * Сворачивать конфиг -- отображается только путь в конфиге.
  * Полный конфиг -- классы отображаются со всеми наследуемыми свойствами.


Горячие клавиши:

|Enter|выполнить sqf-выражение|
|:----|:----------------------------------------|
|Ctrl+Enter|создать watcher для sqf-выражения|
|Ctrl+C, Ctrl+Insert|копировать блок или строку в буфер обмена|
|Alt+]|перейти от открывающей к закрывающей скобке|
|Alt+[|перейти от закрывающей к открывающей скобке|
|Alt+1|переключает в поле ввода команд|
|Alt+2|переключает в окно «Результат»|
|Alt+3|переключает в окно «Копировать»|
|Alt+4|переключает в окно «История»|
|Alt+5|переключает в окно «Процессы»|
|Alt+6|переключает в окно «Демо»|
|Alt+7|переключает в окно «Помощь»|
|Alt+Стрелка влево|переключиться на соседнее левое окно|
|Alt+Стрелка вправо|переключиться на соседнее правое окно|


Вы можете, также, настроить горячие клавиши в файле настроек «\userconfig\sqf-calculator\settings» ([справка по кодам клавиш](http://ru.armacomref.wikia.com/wiki/DIK_KeyCodes)):

```
    // Файл «arma2folder\userconfig\sqf-calculator\settings»
    // Постоянные пункты истории, часто используемые выражения, сниппеты
    _myHistory = [
        'weapons player',
        'magazines player',
        'configFile >> "CfgVehicles" >> typeOf cursorTarget',
        'call compile preprocessFileLineNumbers ".sqf"'
    ];

    //
    // Горячие клавиши, директ икс инпут коды, работают с зажатой ALT
    // Раскоментируйте и отредактируйте при необходимости нужные Вам строки
    // Открыть окно консоли
    //_HKOpenConsole = 0x3B; // F1 key
    //_HKOpenConsole = 0x29; // tilda (~) key 
    // Переключится в поле ввода команд
    //_HKInput = 2;
    // Переключится в окно «Результат»
    //_HKDisplay = 3;
    // Переключится в окно «Копировать»
    //_HKDisplay2 = 4;
    // Переключится в окно «История»
    //_HKHistory = 0x23;
    // Переключится в окно «Процессы»
    //_HKProcesses = 0x24
    // Переключится в окно «Демо»
    //_HKDemo = 0x20;
    // Переключится в окно «Помощь»
    //_HKHelp = 0x3B;
    // Переключится на соседнее левое окно
    //_HKLeft =
    // Переключится на соседнее правое окно
    //_HKRight =
    //

    // Удобные при работе сокращения
    cfg = configFile;
    cfgA = configFile >> "CfgAmmo";
    cfgM = configFile >> "CfgMagazines";
    cfgW = configFile >> "CfgWeapons";
    cfgV = configFile >> "CfgVehicles";
```