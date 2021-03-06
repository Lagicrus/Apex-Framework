/*/
File: fn_scGeneratePositions.sqf
Author: 

	Quiksilver

Last Modified:

	12/09/2017 A3 1.76 by Quiksilver

Description:

	Generate SC Positions
____________________________________________________________________________/*/
diag_log '***** SC * Generating positions * 0 *****';
params ['_numberOfSectors','_module_fob_enabled','_scAreaPolygon'];
private _playerCount = count allPlayers;
private _aoSize = 10;
private _minDistBetweenSectors = 600;
private _minDistFromUsedPositions = 100;
if (worldName isEqualTo 'Altis') then {
	if (_playerCount > 10) then {
		if (_playerCount > 20) then {
			if (_playerCount > 30) then {
				if (_playerCount > 40) then {
					if (_playerCount > 50) then {
						_minDistBetweenSectors = 500;
					} else {
						_minDistBetweenSectors = 500;
					};
				} else {
					_minDistBetweenSectors = 500;
				};
			} else {
				_minDistBetweenSectors = 450;
			};
		} else {
			_minDistBetweenSectors = 400;
		};
	} else {
		_minDistBetweenSectors = 350;
	};
} else {
	if (_playerCount > 10) then {
		if (_playerCount > 20) then {
			if (_playerCount > 30) then {
				if (_playerCount > 40) then {
					if (_playerCount > 50) then {
						_minDistBetweenSectors = 500;
					} else {
						_minDistBetweenSectors = 500;
					};
				} else {
					_minDistBetweenSectors = 500;
				};
			} else {
				_minDistBetweenSectors = 450;
			};
		} else {
			_minDistBetweenSectors = 400;
		};
	} else {
		_minDistBetweenSectors = 350;
	};
};
private _minDistFromLastRefPos = 1000;
private _referencePosition = [0,0,0];
private _nearestLocations = [];
private _requireNearSettlement = (random 1) > 0.333;
private _requireNearSettlementRadius = 500;
private _timeLimitToFind = diag_tickTime + 15;
private _timeLimitFailsafe = diag_tickTime + 60;
private _distFromLastRefPositions = 1250;
if (_module_fob_enabled) then {
	missionNamespace setVariable ['QS_registeredPositions',[(markerPos 'QS_marker_module_fob')],FALSE];
	for '_x' from 0 to 1 step 0 do {
		_referencePosition = [
			'WORLD',
			-1,
			-1,
			'LAND',
			[-1,-1,-1,-1,0,FALSE,objNull],
			TRUE,
			[],
			[],
			TRUE
		] call (missionNamespace getVariable 'QS_fnc_findRandomPos');
		if (diag_tickTime > _timeLimitToFind) then {
			if (_requireNearSettlement) then {
				_requireNearSettlement = FALSE;
			};
			if (diag_tickTime > _timeLimitFailsafe) then {
				missionNamespace setVariable ['QS_virtualSectors_regionUsedRefPositions',[[-1000,-1000,0]],FALSE];
			};
		};
		if (_requireNearSettlement) then {
			_nearestLocations = nearestLocations [_referencePosition,['NameVillage','NameCity','NameCityCapital'],_requireNearSettlementRadius];
		};
		if ((((_requireNearSettlement) && (!(_nearestLocations isEqualTo []))) || (!(_requireNearSettlement))) && (_referencePosition inPolygon _scAreaPolygon) && ((_referencePosition distance2D (missionNamespace getVariable 'QS_virtualSectors_lastReferencePosition')) >= _minDistFromLastRefPos) && ((_referencePosition distance2D (markerPos 'QS_marker_base_marker')) > 1500) && (({((_referencePosition distance2D _x) < _distFromLastRefPositions)} count (missionNamespace getVariable 'QS_virtualSectors_regionUsedRefPositions')) isEqualTo 0)) exitWith {};
	};
} else {
	for '_x' from 0 to 1 step 0 do {
		_referencePosition = [
			'WORLD',
			-1,
			-1,
			'LAND',
			[-1,-1,-1,-1,0,FALSE,objNull],
			TRUE,
			[],
			[],
			TRUE
		] call (missionNamespace getVariable 'QS_fnc_findRandomPos');
		if (_requireNearSettlement) then {
			_nearestLocations = nearestLocations [_referencePosition,['NameVillage','NameCity','NameCityCapital'],_requireNearSettlementRadius];
		};
		if ((((_requireNearSettlement) && (!(_nearestLocations isEqualTo []))) || (!(_requireNearSettlement))) && ((_referencePosition distance2D (missionNamespace getVariable 'QS_virtualSectors_lastReferencePosition')) >= _minDistFromLastRefPos) && (({((_referencePosition distance2D _x) < 1500)} count (missionNamespace getVariable 'QS_virtualSectors_regionUsedRefPositions')) isEqualTo 0)) exitWith {};
	};
};
missionNamespace setVariable ['QS_virtualSectors_lastReferencePosition',_referencePosition,FALSE];
private _fobMarkerPos = [0,0,0];
_minDistFromFOB = 300;
if (_module_fob_enabled) then {
	_fobMarkerPos = markerPos 'QS_marker_module_fob';
};
private _attempts = 0;
missionNamespace setVariable ['QS_virtualSectors_positions',[],FALSE];
private _maxAttempts = 500;
private _foundPositionData = [];
private _position = [0,0,0];
private _foundPositionType = '';
_timeLimitToFind = diag_tickTime + 15;
_timeLimitFailsafe = diag_tickTime + 60;
private _processFailed = FALSE;
diag_log format ['***** SC * Generating positions * 0.5 * Reference Position: %1 *****',_referencePosition];
for '_x' from 0 to 1 step 0 do {
	_attempts = _attempts + 1;
	_foundPositionData = _referencePosition call (missionNamespace getVariable 'QS_fnc_scFindPosition');
	_position = _foundPositionData select 0;
	_foundPositionType = _foundPositionData select 1;
	if ((!(_module_fob_enabled)) || {((_module_fob_enabled) && ((_position distance2D _fobMarkerPos) >= _minDistFromFOB))}) then {
		if (({((_position distance2D _x) < _minDistBetweenSectors)} count (missionNamespace getVariable 'QS_virtualSectors_positions')) isEqualTo 0) then {
			if (({((_position distance2D _x) < _minDistFromUsedPositions)} count (missionNamespace getVariable 'QS_virtualSectors_regionUsedPositions')) isEqualTo 0) then {
				if (((count (missionNamespace getVariable 'QS_virtualSectors_positions')) isEqualTo 0) || ((!((count (missionNamespace getVariable 'QS_virtualSectors_positions')) isEqualTo 0)) && (({([_position,_x,25] call (missionNamespace getVariable 'QS_fnc_waterIntersect'))} count (missionNamespace getVariable 'QS_virtualSectors_positions')) isEqualTo 0))) then {
					if ((!(surfaceIsWater _position)) && (!(_position isEqualTo [0,0,0]))) then {
						(missionNamespace getVariable 'QS_virtualSectors_positions') pushBack _position;
						missionNamespace setVariable ['QS_registeredPositions',((missionNamespace getVariable 'QS_registeredPositions') + [_position]),FALSE];
					};
				};
			};
		};
	};
	if (diag_tickTime > _timeLimitFailsafe) exitWith {
		_processFailed = TRUE;
	};
	if ((count (missionNamespace getVariable 'QS_virtualSectors_positions')) isEqualTo _numberOfSectors) exitWith {
		_centroid = (missionNamespace getVariable 'QS_virtualSectors_positions') call (missionNamespace getVariable 'QS_fnc_geomPolygonCentroid');
		/*/_centroid = (((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) vectorAdd ((missionNamespace getVariable 'QS_virtualSectors_positions') select 1) vectorAdd ((missionNamespace getVariable 'QS_virtualSectors_positions') select 2)) vectorMultiply (1/3);/*/
		missionNamespace setVariable ['QS_virtualSectors_centroid',_centroid,FALSE];
		missionNamespace setVariable ['QS_virtualSectors_lastReferenceCentroid',_centroid,FALSE];
		{
			_x setMarkerPos _centroid;
		} forEach [
			'QS_marker_aoMarker',
			'QS_marker_aoCircle'
		];
		_dirAB = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) getDir ((missionNamespace getVariable 'QS_virtualSectors_positions') select 1);
		_distAB = (((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) distance2D ((missionNamespace getVariable 'QS_virtualSectors_positions') select 1)) / 2;
		_midpointAB = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) getPos [_distAB,_dirAB];
		_dirAC = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) getDir ((missionNamespace getVariable 'QS_virtualSectors_positions') select 2);
		_distAC = (((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) distance2D ((missionNamespace getVariable 'QS_virtualSectors_positions') select 2)) / 2;
		_midpointAC = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 0) getPos [_distAC,_dirAC];
		_dirBC = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 1) getDir ((missionNamespace getVariable 'QS_virtualSectors_positions') select 2);
		_distBC = (((missionNamespace getVariable 'QS_virtualSectors_positions') select 1) distance2D ((missionNamespace getVariable 'QS_virtualSectors_positions') select 2)) / 2;
		_midpointBC = ((missionNamespace getVariable 'QS_virtualSectors_positions') select 1) getPos [_distBC,_dirBC];
		missionNamespace setVariable ['QS_virtualSectors_midpoints',[_midpointAB,_midpointAC,_midpointBC],FALSE];
		missionNamespace setVariable ['QS_AOpos',_centroid,FALSE];
		(missionNamespace getVariable 'QS_virtualSectors_regionUsedCentroids') pushBack _centroid;
		(missionNamespace getVariable 'QS_virtualSectors_regionUsedRefPositions') pushBack _referencePosition;
		while {(!((count((missionNamespace getVariable 'QS_virtualSectors_positions') inAreaArray [_centroid,_aoSize,_aoSize,0,FALSE,-1])) isEqualTo _numberOfSectors))} do {
			_aoSize = _aoSize + 10;
		};
		_aoSize = _aoSize + 100;
		missionNamespace setVariable ['QS_aoSize',_aoSize,FALSE];
		'QS_marker_aoCircle' setMarkerSize [_aoSize,_aoSize];
	};
	if (_attempts > _maxAttempts) exitWith {};
};
diag_log '***** SC * Generating positions * 1 *****';
(missionNamespace getVariable 'QS_virtualSectors_positions')