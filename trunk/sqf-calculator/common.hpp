// SQF
//
// Copyright (c) 2009 Denis Usenko (DenVdmj@gmail.com)
// MIT-style license
//

#define __project_prefix vdmj/calc

#define __project_var_prefix __project_prefix##_var_
#define __project_func_prefix __project_prefix##_func_

#define __quoted(str) #str
#define __uiSet(name, value) uiNamespace setVariable [__quoted(/__project_prefix/name), value]
#define __uiGet(name) (uiNamespace getVariable __quoted(/__project_prefix/name))

#define var(varname) __project_var_prefix##varname
#define func(funcname) __project_func_prefix##funcname
#define invoke(funcname) call func(funcname)

#define preprocessFile preprocessFileLineNumbers

//
// Arguments macro
//

#define arg(x)            (_this select (x))
#define argIf(x)          if(count _this > (x))
#define argIfType(x,t)    if(argIf(x)then{typeName arg(x) == (t)}else{false})
#define argSafe(x)        argIf(x)then{arg(x)}
#define argSafeType(x,t)  argIfType(x,t)then{arg(x)}
#define argOr(x,v)        (argSafe(x)else{v})

//
// Array macro
//

#define item(a,v)  ((a)select(((v)min(count(a)-1))max 0))
#define itemr(a,v) (item((a),if((v)<0)then{count(a)+(v)}else{v}))
#define __push(a,v)  (a)set[count(a),(v)]
#define __pushTo(a)  call{(a)set[count(a),_this]}
#define __top(a)     ((a)select((count(a)-1)max 0))
#define __pop(a)     (0 call{_this=__top(a);a resize((count(a)-1)max 0);_this})
#define __selectRnd(a) (a select floor random count a)

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

#define __logN(power,number) ((log number)/(log power))
#define __log2(number) ((log number)/.3010299956639812)
#define getBit(num,bit) (floor((num / (2^bit)) % 2))
#define checkBit(num,bit) (getBit(num,bit) == 1)
#define __xor(a,b) (!(a && b) && (a || b))
#define __inc(n) (call { n = n + 1; n })
#define __dec(n) (call { n = n - 1; n })
#define _(v)   _##v = _##v

//
// for, map, grep
//

#define __forConf(list) call { private ["_x", "___n"]; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; private "___n"; _x call _this; }; }
#define __mapArray(list) call { private "___r"; ___r = []; { ___r set [count ___r, call { private "___r"; _x call _this }] } foreach (list); ___r; }
#define __grepArray(list) call { private "___r"; ___r = []; { if( call { private "___r"; _x call _this } ) then { __push(___r, _x) } } foreach (list); ___r; }
#define __map(list) call { private ["___r", "___n", "_x"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; ___r set [count ___r, call { private ["___r", "___n"]; call _this }] }; ___r; }
#define __grep(list) call { private ["___r", "___n", "_x"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { _x = ___n select _i; if( call { private ["___r", "___n"]; _x call _this } ) then { __push(___r, _x) } }; ___r; }

//
// Type of expression
//

#define isCode(v) (typeName(v) == "CODE")
#define isNum(v)  (typeName(v) == "SCALAR")
#define isHNDL(v) (typeName(v) == "SCRIPT")
#define isSide(v) (typeName(v) == "SIDE")
#define isSTML(v) (typeName(v) == "TEXT")

#define isArr(v)  (typeName(v) == "ARRAY")
#define isBool(v) (typeName(v) == "BOOL")
#define isConf(v) (typeName(v) == "CONFIG")
#define isCtrl(v) (typeName(v) == "CONTROL")
#define isDspl(v) (typeName(v) == "DISPLAY")
#define isGrp(v)  (typeName(v) == "GROUP")
#define isObj(v)  (typeName(v) == "OBJECT")
#define isStr(v)  (typeName(v) == "STRING")

