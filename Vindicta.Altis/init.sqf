#define OOP_INFO
#define OOP_DEBUG
#include "OOP_Light\OOP_Light.h"

// Looks kind of empty since all was moved elsewhere, we need to remove the file probably

GLX_Path = "GLX_System\";
execVM (GLX_Path+"GLX_Initialize.sqf");

// Disable initialize of GLX in this mission.
//
// GLX_Initialize = False;
//
/////////////////////////////////////////////

GLX_AI =
[
	2,							// A.I. vs Enemy Knowledge (0-4) need to have about their enemy(s) to requesting reinforcement(s).
	0.15,						// A.I. vs Enemy Rating (0-1)
	2,							// A.I. Reinforcement Request Amount (0-30 groups)
	300							// A.I. Enemy Search Duration (30-500)
];

GLX_IQ =
[
	5							// A.I. Enemy Knowledge Duration after loss line of sight (0-7)
];

GLX_Radio =
[
	30,							// A.I. Reinforcement Request Time (0-100)
	[500, 3000, 5000, 7000]	// A.I. Reinforcement Request Distance [Man, Car, Tank, Air, Ship]
];

GLX_Debug =
[
	False,	// Initialize Debug
	False,	// Map Marker Debug
	False,	// 3D Icon Debug
	False	// Cursor Debug
];

// Code which adds all objects to be edited by zeus
if (isServer) then {
    [] spawn {
        scriptName "Add Curator Objects";
        sleep 5;
        while {true} do {
            {
                _x addCuratorEditableObjects [allUnits, true];
                _x addCuratorEditableObjects [vehicles, true];
                sleep 10;
            } forEach allCurators;
        };
    };
};
