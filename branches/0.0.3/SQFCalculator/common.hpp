// sqf
// common macros
// Copyright (c) 2009 Denis Usenko (DenVdmj)
// MIT-style license
//

#ifndef __rls_prefix
    #define __rls_prefix rls_
#endif

#ifndef __rls_present
#define __rls_present present

#define __rls_var_prefix __rls_prefix##var_
#define __rls_func_prefix __rls_prefix##func_
#define var(varname) __rls_var_prefix##varname
#define func(funcname) __rls_func_prefix##funcname
#define invoke(funcname) call func(funcname)

//
//
//

#define print player sideChat
#define preprocessFile preprocessFileLineNumbers
#define currentLangAbbr (localize "STR:RLS:CURRENT_LANG_ABBR")

//
// Arguments macro
//

#define arg(X)            (_this select (X))
#define argIf(X)          if(count _this > (X))
#define argIfType(X,T)    if(argIf(X)then{typeName arg(X) == (T)}else{false})
#define argSafe(X)        argIf(X)then{arg(X)}
#define argSafeType(X,T)  argIfType(X,T)then{arg(X)}
#define argOr(X,V)        (argSafe(X)else{V})

//
// Array macro
//

#define item(A,V)   ((A)select(((V) min (count(A)-1)) max 0))
#define itemr(A,V)  (item((A), if((V) < 0)then{count(A)+(V)}else{V}))
#define push(A,V)   (A)set[count(A),(V)]
#define pushTo(array) call { array set [count array, _this] }
#define top(A)      ((A)select((count(A) - 1) max 0))
#define pop(A)      (0 call { _this = top(A); A resize ((count(A) - 1) max 0); _this })

//
// Position macro
//

#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)

//
// Other macro
//

#define logN(power,number) ((log number)/(log power))
#define log2(number) ((log number)/.3010299956639812)
#define getBit(num,bit) (floor((num / (2^bit)) % 2))
#define checkBit(num,bit) (getBit(num,bit) == 1)
#define xor(a,b) (!(a && b) && (a || b))
#define inc(N)   (call { N = N + 1; N })
#define dec(N)   (call { N = N - 1; N })
#define _(V)     _##V = _##V

#define is       isKindOf

//
// for, map, grep
//

#define forConf(list) call { private ["_x", "___n"]; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; private "___n"; call _this; }; }
#define mapArray(list) call { private "___r"; ___r = []; { ___r set [count ___r, call { private "___r"; call _this }] } foreach (list); ___r; }
#define grepArray(list) call { private "___r"; ___r = []; { if( call { private "___r"; call _this } ) then { push(___r, _x) } } foreach (list); ___r; }
#define map(list) call { private ["___r", "___n", "_x"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; ___r set [count ___r, call { private ["___r", "___n"]; call _this }] }; ___r; }
#define grep(list) call { private ["___r", "___n", "_x"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; if( call { private ["___r", "___n"]; call _this } ) then { push(___r, _x) } }; ___r; }

//
// Type of expression
//

#define isCode(V) (typeName(V) == "CODE")
#define isNum(V)  (typeName(V) == "SCALAR")
#define isHNDL(V) (typeName(V) == "SCRIPT")
#define isSide(V) (typeName(V) == "SIDE")
#define isSTML(V) (typeName(V) == "TEXT")

#define isArr(V)  (typeName(V) == "ARRAY")
#define isBool(V) (typeName(V) == "BOOL")
#define isConf(V) (typeName(V) == "CONFIG")
#define isCtrl(V) (typeName(V) == "CONTROL")
#define isDspl(V) (typeName(V) == "DISPLAY")
#define isGrp(V)  (typeName(V) == "GROUP")
#define isObj(V)  (typeName(V) == "OBJECT")
#define isStr(V)  (typeName(V) == "STRING")


#define __ManPosLyingBinoc  2
#define __ManPosStandBinoc 14
#define __ManPosDead        0
#define __ManPosLyingRfl    4
#define __ManPosKneelBinoc 13
#define __ManPosLyingHnd    5
#define __ManPosKneelRfl    6
#define __ManPosStandRfl    8
#define __ManPosStand      10
#define __ManPosSwimming   11
#define __ManPosWeapon      1
#define __ManPosKneelHnd    7
#define __ManPosStandHnd    9
#define __ManPosLyingCivil  3
#define __ManPosStandCivil 12

#define __WeaponNoSlot            0
#define __WeaponSlotPrimary       1
#define __WeaponSlotHandGun       2
#define __WeaponSlotSecondary     4
#define __WeaponSlotMaschinegun   5
#define __WeaponSlotHandGunMag   16
#define __WeaponSlotHandGunMag2  32
#define __WeaponSlotHandGunMag3  48
#define __WeaponSlotHandGunMag4  64
#define __WeaponSlotHandGunMag5  80
#define __WeaponSlotHandGunMag6  96
#define __WeaponSlotHandGunMag7 112
#define __WeaponSlotHandGunMag8 128
#define __WeaponSlotMag         256
#define __WeaponSlotMag2        512
#define __WeaponSlotMag3        768
#define __WeaponSlotMag4       1024
#define __WeaponSlotGoggle     4096
#define __WeaponHardMounted   65536

#define __prflrStart diag_log ":: profiler start"; rls_diag_profiler_time = diag_ticktime;
#define __prflr_(text) diag_log (diag_ticktime - rls_diag_profiler_time); diag_log text; rls_diag_profiler_time = diag_ticktime;
#define __prflr(cmd) diag_log '>> cmd'; rls_diag_profiler_time = diag_ticktime; cmd; diag_log (diag_ticktime - rls_diag_profiler_time); rls_diag_profiler_time = diag_ticktime;


#endif