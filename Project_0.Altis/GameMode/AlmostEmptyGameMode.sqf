#include "common.hpp"

#define N_LOCATIONS_OCCUPIED 3

#define pr private

CLASS("AlmostEmptyGameMode", "GameModeBase")

	VARIABLE("nLocationsInitialized");

	METHOD("new") {
		params [P_THISOBJECT];
		T_SETV("name", "expand");
		T_SETV("spawningEnabled", false);
		T_SETV("nLocationsInitialized", 0);
	} ENDMETHOD;

	METHOD("delete") {
		params [P_THISOBJECT];

	} ENDMETHOD;
	
	// Initialize just a few outposts
	/* protected virtual */ METHOD("getLocationOwner") {
		params [P_THISOBJECT, P_OOP_OBJECT("_loc")];
		OOP_DEBUG_MSG("%1", [_loc]);

		private _type = CALLM0(_loc, "getType");

		// Disable city garrisons
		if (_type isEqualTo LOCATION_TYPE_CITY) exitWith {
			sideEmpty
		};

		private _counter = T_GETV("nLocationsInitialized");
		if (_counter > N_LOCATIONS_OCCUPIED) exitWith {CIVILIAN};

		T_SETV("nLocationsInitialized", _counter + 1);

		if(GETV(_loc, "type") == LOCATION_TYPE_OUTPOST) then {
			WEST
		} else {
			CIVILIAN
		};
	} ENDMETHOD;

	METHOD("getRecruitCount") {
		params [P_THISOBJECT, P_ARRAY("_cities")];
		100
	} ENDMETHOD;

	METHOD("getRecruitmentRadius") {
		params [P_THISCLASS];
		10000
	} ENDMETHOD;

	METHOD("initLocationGameModeData") {
		params [P_THISOBJECT, P_OOP_OBJECT("_loc")];
		private _type = CALLM0(_loc, "getType");
		private _data = NEW("AlmostEmptyLocationData", [_loc]);
		SETV(_loc, "gameModeData", _data);
		
		PUBLIC_VAR(_loc, "gameModeData");

		// Update respawn rules
		if (_type != LOCATION_TYPE_CITY) then { // Cities will search for other nearby locations which will slow down everything probably, let's not use that
			private _gmdata = CALLM0(_loc, "getGameModeData");
			CALLM0(_gmdata, "updatePlayerRespawn");
		};

		// Return
		CALLM0(_loc, "getGameModeData")
	} ENDMETHOD;

	METHOD("initServerOnly") {
		params [P_THISOBJECT];
				
		// Create LocationGameModeData objects for all locations
		{
			private _loc = _x;
			T_CALLM1("initLocationGameModeData", _loc);
		} forEach GET_STATIC_VAR("Location", "all");
	} ENDMETHOD;

ENDCLASS;

CLASS("AlmostEmptyLocationData", "LocationGameModeData")

	METHOD("new") {
		params [P_THISOBJECT];
	} ENDMETHOD;

	/* virtual override */ METHOD("updatePlayerRespawn") {
		params [P_THISOBJECT];

		pr _loc = T_GETV("location");
		pr _capInf = CALLM0(_loc, "getCapacityInf");
		pr _garrisons = CALLM0(_loc, "getGarrisons");
		pr _sidesOccupied = [];
		{_sidesOccupied pushBackUnique (CALLM0(_x, "getSide"))} forEach _garrisons;
		{
			//  We can respawn here if there is a garrison of our side
			pr _enable = (_x in _sidesOccupied);
			CALLM2(_loc, "enablePlayerRespawn", _x, _enable);
		} forEach [WEST, EAST, INDEPENDENT];
	} ENDMETHOD;

ENDCLASS;