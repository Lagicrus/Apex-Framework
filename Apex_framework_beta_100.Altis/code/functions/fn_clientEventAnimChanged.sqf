/*/
File: fn_clientEventAnimChanged.sqf
Author: 

	Quiksilver
	
Last modified:

	8/10/2017 ArmA 1.76 by Quiksilver
	
Description:

	Anim Changed Event
___________________________________________________________________/*/
params ['_unit','_anim'];
if (_anim in ['acinpknlmstpsraswrfldnon','acinpknlmstpsnonwpstdnon','acinpknlmstpsnonwnondnon']) then {
	comment 'Dragging';
	if (scriptDone QS_anim_script) then {
		QS_anim_script = _this spawn {
			params ['_unit','_anim'];
			scriptName 'QS Anim Handler - Dragging';
			private _startTime = diag_tickTime + 300;
			for '_x' from 0 to 1 step 0 do {
				if (diag_tickTime > _startTime) exitWith {};
				if (!alive player) exitWith {};
				if (!isNull (objectParent player)) exitWith {};
				if (!((lifeState player) in ['HEALTHY','INJURED'])) exitWith {};
				if (({((!isNull _x) && (!(_x isKindOf 'sign_sphere10cm_f')))} count (attachedObjects player)) isEqualTo 0) exitWith {
					player playActionNow 'released';
				};
				uiSleep 1;
			};
		};
	};
};
if (_anim in ['ainjppnemrunsnonwnondb_still','ainjppnemrunsnonwrfldb_still','ainjppnemrunsnonwpstdb_still']) then {
	comment 'Dragged';
	if (scriptDone QS_anim_script) then {
		QS_anim_script = _this spawn {
			params ['_unit','_anim'];
			scriptName 'QS Anim Handler - Dragged';
			uiSleep 3;
			private _attachedTo = attachedTo _unit;
			for '_x' from 0 to 1 step 0 do {
				_attachedTo = attachedTo _unit;
				if (isNull _attachedTo) exitWith {_unit playActionNow 'released';};
				if (!alive _unit) exitWith {};
				if (!alive _attachedTo) exitWith {_unit playActionNow 'released';};
				if (!isNull (objectParent _unit)) exitWith {};
				if (!((lifeState _unit) in ['HEALTHY','INJURED'])) exitWith {};
				if (!((lifeState _attachedTo) in ['HEALTHY','INJURED'])) exitWith {detach _unit;_unit playActionNow 'released';};
				if (!isNull (objectParent _attachedTo)) exitWith {detach _unit;_unit playActionNow 'released';};
				uiSleep 1;
			};	
		};
	};
};
if (_anim in ['acinpercmstpsraswrfldnon','acinpercmstpsraswnondnon','acinpercmstpsraswpstdnon','acinpercmstpsnonwnondnon']) then {
	comment 'Carrying';
	if (scriptDone QS_anim_script) then {
		QS_anim_script = _this spawn {
			params ['_unit','_anim'];
			scriptName 'QS Anim Handler - Carrying';
			uiSleep 3;
			private _startTime = diag_tickTime + 300;
			private _putDown = FALSE;
			for '_x' from 0 to 1 step 0 do {
				if (diag_tickTime > _startTime) exitWith {};
				if (!alive player) exitWith {_putDown = TRUE;};
				if (!isNull (objectParent player)) exitWith {_putDown = TRUE;};
				if (!((lifeState player) in ['HEALTHY','INJURED'])) exitWith {};
				if (({((!isNull _x) && (!(_x isKindOf 'sign_sphere10cm_f')))} count (attachedObjects player)) isEqualTo 0) exitWith {
					player playActionNow 'released';
				};
				if (!(({((_x isKindOf 'Man') && (!((lifeState _x) isEqualTo 'INCAPACITATED')))} count (attachedObjects player)) isEqualTo 0)) exitWith {
					{
						detach _x;
					} count attachedObjects player;
					player playActionNow 'released';
				};
				uiSleep 1;
			};
			if (_putDown) then {
			
			};
		};
	};
};
if (_anim in ['ainjpfalmstpsnonwrfldnon_carried_still','ainjpfalmstpsnonwnondnon_carried_still','ainjpfalmstpsnonwnondf_carried_dead','ainjpfalmstpsnonwnondnon_carried_up']) then {
	comment 'Carried';
	if (scriptDone QS_anim_script) then {
		QS_anim_script = _this spawn {
			params ['_unit','_anim'];
			scriptName 'QS Anim Handler - Carried';
			uiSleep 3;
			private _attachedTo = attachedTo _unit;
			private _putDown = FALSE;
			for '_x' from 0 to 1 step 0 do {
				_attachedTo = attachedTo _unit;
				if (isNull _attachedTo) exitWith {_putDown = TRUE;};
				if (!alive _unit) exitWith {};
				if (!alive _attachedTo) exitWith {_putDown = TRUE;};
				if (!isNull (objectParent _unit)) exitWith {};
				if ((lifeState _unit) in ['HEALTHY','INJURED']) exitWith {_putDown = TRUE;};
				if (!((lifeState _attachedTo) in ['HEALTHY','INJURED'])) exitWith {_putDown = TRUE;};
				if (!isNull (objectParent _attachedTo)) exitWith {_putDown = TRUE;};
				uiSleep 1;
			};
			if (_putDown) then {
				if (!(_unit getVariable ['QS_RD_loaded',FALSE])) then {
					detach _unit;
				};
			};
		};
	};
};