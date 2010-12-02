private "_data";
_data = call compile preprocessFile ("\userconfig\SQFCalculator\envs\" + _this);
setDate (_data select 0);
0 setFog (_data select 1);
100 setFog (_data select 1);
0 setOvercast (_data select 2);
100 setOvercast (_data select 2);
0 setRain (_data select 3);
100 setRain (_data select 3);
