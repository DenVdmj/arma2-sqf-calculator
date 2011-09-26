// ARMA2

#define RECT(X,Y,W,H) \
    x=__EVAL(X); \
    y=__EVAL(Y); \
    w=__EVAL(W); \
    h=__EVAL(H)


#define __STRINGTABLE_PREFIX STR/VDMJ/SQFConsole
#define __Q(VALUE) #VALUE
#define __L(VALUE) __Q(__STRINGTABLE_PREFIX/VALUE)
#define L(VALUE) __EVAL(localize __L(VALUE))
#define FORMAT_L(TPL,VALUE) __EVAL(format [TPL, localize __L(VALUE)])

#define fontsize 0.034

class RscVdmjSqfCalculator {

    class RscRLSScrollBar {
        color[] = {1, 1, 1, 0.6};
        colorActive[] = {1, 1, 1, 1};
        colorDisabled[] = {1, 1, 1, 0.3};
        thumb = "\ca\ui\data\igui_scrollbar_thumb_ca.paa";
        arrowFull = "\ca\ui\data\igui_arrow_top_active_ca.paa";
        arrowEmpty = "\ca\ui\data\igui_arrow_top_ca.paa";
        border = "\ca\ui\data\igui_border_scroll_ca.paa";
    };

    class RscRLSControlsGroup: RscControlsGroup {
        style = 0x10;
        class ScrollBar: RscRLSScrollBar {};
        class VScrollbar {
            color[] = {1, 1, 1, 1};
            width = 0.021;
            autoScrollSpeed = -1;
            autoScrollDelay = 5;
            autoScrollRewind = 0;
        };
        class HScrollbar {
            color[] = {1, 1, 1, 1};
            height = 0.028;
        };
    };

    class RscRLSText : RscText {
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {0.6640625, 0.6875, 0.56640625, 1};
        sizeEx = 0.03921;
    };

    class RscRLSToolbox {
        access = 2;
        type = 6;
        style = 2;
        colorText[] = {0.543, 0.5742, 0.4102, 1};
        color[] = {0.95, 0.95, 0.95, 1};
        colorTextSelect[] = {0.79296875, 0.80859375, 0.734375, 1};
        colorSelect[] = {0.95, 0.95, 0.95, 1};
        colorTextDisable[] = {0.4, 0.4, 0.4, 1};
        colorDisable[] = {0.4, 0.4, 0.4, 1};
        coloSelectedBg[] = {0, 0, 0, 1};
        font = "Zeppelin32";
        sizeEx = 0.02674;
    };

    class RscRLSListBox : RscListBox {
        rowHeight = 0;
        colorText[] = {0.6640625, 0.6875, 0.56640625, 1};
        colorScrollbar[] = {0.95, 0.95, 0.95, 1};
        colorSelect[] = {0.95, 0.95, 0.95, 1};
        colorSelect2[] = {0.95, 0.95, 0.95, 1};
        colorSelectBackground[] = {0.3359375, 0.35546875, 0.2578125, 1};
        colorSelectBackground2[] = {0.543, 0.5742, 0.4102, 1};
        colorBackground[] = {0, 0, 0, 1};
        font = "Zeppelin32";
        sizeEx = 0.03921;
        color[] = {1, 1, 1, 1};
        maxHistoryDelay = 1;
        autoScrollSpeed = -1;
        autoScrollDelay = 5;
        autoScrollRewind = 0;
        class ScrollBar: RscRLSScrollBar {};
    };

    class RscRLSButton : RscButton {
        access = 2;
        type = 1;
        style = "0x102";
        text = "";
        colorText[] = {0.543, 0.5742, 0.4102, 1};
        colorDisabled[] = {0.4, 0.4, 0.4, 1};
        colorBackground[] = {0, 0, 0, 0.5};
        colorBackgroundDisabled[] = {0, 0, 0, .3};
        colorBackgroundActive[] = {0, 0, 0, .7};
        colorFocused[] = {0, 0, 0, .7};
        colorShadow[] = {0, 0, 0, 1};
        colorBorder[] = {0, 0, 0, 1};
        w = 0.09;
        h = 0.04;
        font = "Zeppelin32";
        sizeEx = 0.02674;
        offsetX = 0;
        offsetY = 0;
        offsetPressedX = 0.001;
        offsetPressedY = 0.001;
        borderSize = 0;
    };

    class RscRLSHTML : RscHTML {
        sizeEx = 0.03921;
        text = ;
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {0.6640625, 0.6875, 0.56640625, 1};
        colorBold[] = {0.8203125, 0.8359375, 0.77734375, 1}; //{0.543, 0.5742, 0.4102, 1};
        colorLink[] = {0.6,   0.8392, 0.4706, 1};
        colorLinkActive[] = {1, 0.537, 0, 1};
        colorPicture[] =    {1, 1, 1, 1};
        colorPictureLink[] = {1, 1, 1, 1};
        colorPictureSelected[] = {1, 1, 1, 1};
        colorPictureBorder[] = {0, 0, 0, 0};
        tooltipColorText[] = {0, 0, 0, 1};
        tooltipColorBox[] = {0, 0, 0, 0.5};
        tooltipColorShade[] = {1, 1, 0.7, 1};
        class H1 {
            font = "Zeppelin32";
            fontBold = "Zeppelin33";
            sizeEx = 0.035;
        };
        class H2 {
            font = "Zeppelin32";
            fontBold = "Zeppelin33";
            sizeEx = 0.032;
        };
        class H3 {
            font = "Zeppelin32";
            fontBold = "Zeppelin33";
            sizeEx = 0.03;
        };
        class H4 {
            font = "Zeppelin33Italic";
            fontBold = "Zeppelin33";
            sizeEx = 0.028;
        };
        class H5 {
            font = "Zeppelin32";
            fontBold = "Zeppelin33";
            sizeEx = 0.026;
        };
        class H6 {
            font = "LucidaConsoleB";
            fontBold = "LucidaConsoleB";
            align = "left";
            sizeEx = 0.022;
        };
        class P {
            font = "Zeppelin32";
            fontBold = "Zeppelin33";
            align = "left";
            colorText[] = {1, 1, 1, 1};
            color[] = {1, 1, 1, 1};
            sizeEx = 0.027;
        };
    };

    ////////////

    idd = 78934;
    movingEnable = true;

    class controlsBackground {
        class Mainback : RscPicture {
            idc = -1;
            RECT(0, -.01, 1.28, 1.02);
            text = "\ca\ui\data\ui_background_controls_ca.paa";
            moving = 1;
        };
        class Title : RscStructuredText {
            idc = -1;
            RECT(0, .023, 1, .06);
            class Attributes {
                font = "Zeppelin32";
                color = "#AAB091";
                align = "center";
                shadow = 1;
            };
            text = FORMAT_L("<t size='1.3' align='center'>%1</t>",Title);
            moving = 1;
        };
    };

    class controls {
        class CommonGroup: RscControlsGroup {
            idc = 4;
            RECT(0, .1, 1.28, .90);
            class controls {
                class InputText: RscEdit {
                    idc = 100;
                    RECT(.01, 0, .98, .06);
                    sizeEx = fontsize;
                    autocomplete = "scripting";
                };

                class SelectWin: RscRLSToolbox {
                    idc = 101;
                    RECT(.03, .82, .56, .05);
                    rows = 1;
                    columns = 6;
                    strings[] = {
                        L(Formated),
                        L(Display),
                        L(History),
                        L(Processes),
                        L(Demo),
                        L(Help)
                    };
                };

                class ConfigOutputModeButton: RscRLSButton {
                    idc = 102;
                    RECT(.751, .82, .2, .05);
                    text = L(ConfigOutputMode.AsIs);
                    texts[] = {
                        L(ConfigOutputMode.Full),
                        L(ConfigOutputMode.AsIs),
                        L(ConfigOutputMode.Folded)
                    };
                    toolTip = L(ConfigOutputMode.ConfigOutputMode.toolTip);
                };

                class WatchButton: RscRLSButton {
                    idc = 103;
                    RECT(.65, .82, .09, .05);
                    text = L(Watch);
                };

                class ResultFormated: RscRLSListBox {
                    idc = 201;
                    sizeEx = fontsize;
                    RECT(.01, .07, .98, .7);
                };
                class ResultText: RscEdit {
                    idc = 202;
                    style = ST_MULTI;
                    lineSpacing = 1;
                    sizeEx = fontsize;
                    RECT(.01, .07, .98, .7);
                };
                class HistoryList: RscRLSListBox {
                    idc = 203;
                    RECT(.01, .07, .98, .7);
                    sizeEx = fontsize;
                };
                class ProcessList: RscRLSListBox {
                    idc = 204;
                    RECT(.01, .07, .98, .7);
                    sizeEx = fontsize;
                };
                class DemoFrame: RscRLSControlsGroup {
                    RECT(.01, .07, .98, .7);
                    idc = 205;
                    class controls {
                        class Demo: RscRLSHTML {
                            idc = 1205;
                            RECT(0, 0, .96, .8);
                            colorBorder[] = {0, 0, 0, 1};
                            filename = L(DemoVoidFile);
                            cycleLinks = 1;
                            cycleAllLinks = 1;
                        };
                    };
                };
                class HelpFrame: RscRLSControlsGroup {
                    RECT(.01, .07, .98, .7);
                    idc = 206;
                    class controls {
                        class Help: RscRLSHTML {
                            idc = 1206;
                            RECT(0, 0, .96, 2.4);
                            filename = L(HelpFile);
                            cycleLinks = 1;
                            cycleAllLinks = 1;
                        };
                    };
                };
            };
        };
    };
};

class RscTitles {
    class RscVdmjSqfCalculatorHUD {
        idd = -1;
        movingEnable =  1;
        duration     =  86400 * 100;
        fadein       =  0;
        fadeout      =  0;
        name = ;
        onLoad = "_this call compile preprocessFile '\SQFCalculator\overlay.sqf'";
        class controlsBackground {};
        class objects {};
        class controls {
            class HUD : RscStructuredText {
                idc = 100;
                RECT(0, 0, 1, 1);
                class Attributes {
                    font = "Zeppelin32";
                    color = "#AAB091";
                    align = "center";
                    shadow = 1;
                };
                text = "";
            };
        };
    };
};
