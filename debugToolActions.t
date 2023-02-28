#charset "us-ascii"
//
// debugToolActions.t
//
// Defines a system action that drops control to the interactive debugger.
//
#include <advlite.h>

#include "debugTool.h"

#ifdef __DEBUG_TOOL

// Simple system command that forces a "breakpoint", dropping into the
// interactive debugger.
DefineSystemAction(DebugToolBreakpoint)
	execAction() {
		__debugTool.breakpoint();
		aioSay('Exiting debugger.' );
	}
;
VerbRule(DebugToolBreakpoint) 'breakpoint': VerbProduction
	action = DebugToolBreakpoint
	verbPhrase = 'breakpoint/breakpointing';

#endif // __DEBUG_TOOL
