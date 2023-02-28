#charset "us-ascii"
//
// debugToolEvents.t
//
// Tweaks to the adv3 main event scheduler.  By default runScheduler()
// catches all exceptions, prints them, and then continues execution.
// Here we just insert a call to the interactive debugger in some of
// the "interesting" exception handlers.
//
#include <advlite.h>

#include "debugTool.h"

#ifdef DEBUG_TOOL_CATCH_ALL

// We semi-kludgily replace the main scheduler loop with our own version
// that does everything the same but additionally drops into the interactive
// debugger on "bad" exceptions.
/*
// "Bad" exceptions are the ones that aren't gameplay-related.  T3 somewhat
// ideosyncratically uses exceptions when, for example, in some cases
// when an action's verify() method wants to declare an end to verification
// and that kind of thing.  These aren't the kind of conditions we care
// about catching in the debugger, so we ignore them.
//
// Most of the code below cut and pasted from adv3/events.t
replace runScheduler() {
	local cur, curTime, vec, minTime;

	for(;;) {
		try {
			vec = new Vector(10);
			minTime = nil;
			foreach(cur in Schedulable.allSchedulables) {
				curTime = cur.getNextRunTime();

				if(curTime != nil && (minTime == nil
					|| curTime <= minTime)) {
					if(minTime != nil && curTime < minTime)
						vec.removeRange(1,
							vec.length());
					vec.append(cur);
					minTime = curTime;
				}
			}
			if(minTime == nil) {
				"\b[Error: nothing is available for
					scheduling - terminating]\b";
				return;
			}

			libGlobal.totalTurns += minTime
				- Schedulable.gameClockTime;
			Schedulable.gameClockTime = minTime;
			vec.forEach({x: x.calcScheduleOrder()});
			vec = vec.sort(SortAsc,
				{a, b: a.scheduleOrder - b.scheduleOrder});

		vecLoop:
			foreach(cur in vec) {
				while(cur.getNextRunTime() == minTime) {
					try {
						if (!cur.executeTurn())
							break vecLoop;
					}
					catch(Exception exc) {
						if(cur.getNextRunTime()
							== minTime)
							cur.incNextRunTime(1);
						throw exc;
					}
				}
			}
		}
		catch(EndOfFileException eofExc) { return; }
		catch(QuittingException quitExc) { return; }
		catch(RestartSignal rsSig) { throw rsSig; }
		catch(RuntimeError rtErr) {
			if(rtErr.isDebuggerSignal)
				throw rtErr;
			"\b[<<rtErr.displayException()>>]\b";
			__debugTool.runtimeError(rtErr);
		}
		catch(TerminateCommandException tce) {}
		catch(ExitSignal es) {}
		catch(ExitActionSignal eas) {}
		catch(Exception exc) {
			"\b[Unhandled exception: <<exc.displayException()>>]\b";
			__debugTool.exception(exc);
		}
	}
}
*/

replace mainCommandLoop() {
	local txt;
	gActor = gPlayerChar;
	do {
		if(defined(scoreNotifier) && scoreNotifier.checkNotification())
			;
		if(defined(eventManager) && eventManager.executePrompt())
			;
		try {
			"<.p>";
            
			"<.inputline>";
			DMsg(command prompt, '>');
			txt = inputManager.getInputLine();
			"<./inputline>\n";   
            
			txt = StringPreParser.runAll(txt, Parser.rmcType());
            
			if(txt == nil)
				continue;

			Parser.parse(txt);
		}
		catch(TerminateCommandException tce) {
		}
		catch(RuntimeError rtErr) {
			if(rtErr.isDebuggerSignal)
				throw rtErr;
			"\b[<<rtErr.displayException()>>]\b";
			__debugTool.runtimeError(rtErr);
		}
		catch(Exception exc) {
			"\b[Unhandled exception: <<exc.displayException()>>]\b";
			__debugTool.exception(exc);
		}
		statusLine.showStatusLine();
	} while (true);    
}

#endif // DEBUG_TOOL_CATCH_ALL
