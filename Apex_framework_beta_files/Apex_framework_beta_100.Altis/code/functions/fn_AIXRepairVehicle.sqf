/*/
File: fn_AIXRepairVehicle.sqf
Author:

	Quiksilver
	
Last modified:

	30/10/2017 A3 1.76 by Quiksilver
	
Description:

	AI Behaviour Repair Vehicle
	
Notes:

	Is this script even necessary? addVehicle seems to work fine with a bit of scripting
	addVehicle can only handle 3 vehicles at a time?
__________________________________________________/*/

params [
	['_unit',objNull],
	['_target',objNull],
	['_duration',300],
	['_setRadius',7],
	['_repairFull',FALSE]
];
{
	_unit disableAI _x;
} forEach [
	'AUTOCOMBAT',
	'COVER',
	'AUTOTARGET',
	'TARGET',
	'WEAPONAIM'
];
private _time = diag_tickTime;
_timeout = diag_tickTime + _duration;
_moveDelay = 15;
private _moveCheckDelay = _time + 0;
private _exit = FALSE;
_startPosition = position _unit;
for '_x' from 0 to 1 step 0 do {
	_time = diag_tickTime;
	if ((!alive _unit) || {(!((lifeState _unit) in ['HEALTHY','INJURED']))} || {(!alive _target)}) then {
		_exit = TRUE;
	};
	if ((_unit distance2D _target) > _setRadius) then {
		if (_time > _moveCheckDelay) then {
			_unit forceSpeed -1;
			_unit doMove (position _target);
			_moveCheckDelay = _time + _moveDelay;
		};
	} else {
		_minePosition = position _unit;
		_unit forceSpeed 0;
		_unit setDir (_unit getDir _target);
		uiSleep 0.1;
		_unit action ['repairVehicle',_target];
		[_unit,_target,_repairFull] spawn {
			params ['_unit','_target','_repairFull'];
			uiSleep 7; 
			if (alive _unit) then {
				if (_repairFull) then {
					_target setDamage [0,FALSE];
					if (local _target) then {
						_target setFuel 1;
					} else {
						['setFuel',_target,1] remoteExec ['QS_fnc_remoteExecCmd',_target,FALSE];
					};
				} else {
					_target setDamage [((damage _target) * 0.5),TRUE];
				};
			};
		};
		_unit forceSpeed -1;
		_exit = TRUE;
	};
	if (_exit) exitWith {};
	if (_time > _timeout) exitWith {};
	uiSleep 3;
};
if (!alive _unit) exitWith {};
{
	_unit enableAI _x;
} forEach [
	'AUTOCOMBAT',
	'COVER',
	'AUTOTARGET',
	'TARGET',
	'WEAPONAIM'
];
_unit doMove _startPosition;
_unit doFollow (leader (group _unit));