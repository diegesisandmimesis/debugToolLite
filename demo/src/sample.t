#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the debugTool library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <advlite.h>

versionInfo:    GameID
        name = 'debugTool Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the debugTool library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is just a little demonstration of the behavior you
		get from compiling with -D DEBUG_TOOL_CATCH_ALL.
		<.p>
		This just adds hooks for __debugTool to the exception
		handlers in the game's main event loop, dropping into
		the interactive debugger whenever a <q>bad</q> exception is
		thrown (that is, an exception not related to normal
		parser behavior:  runtime errors are <q>bad</q>, a verify()
		method terminating command processing is not).
		<.p>
		The pebble.dobjFor(Take) handler has a (deliberate)
		error that will generate a runtime error, so you can see
		this in action by typing >TAKE PEBBLE.
		<.p>
		Consult the README.txt document distributed with the library
		source for a quick summary of how to use the library in your
		own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

startRoom: Room 'Void'
        "This is a featureless void."
;
+me: Thing
	isFixed = true
	proper = true
	ownsContents = true
	person = 2
	contType = Carrier
;
+pebble: Thing 'pebble'
	"A small, round pebble. "

	foozle = nil

	dobjFor(Take) {
		// This since foozle is nil, this will throw a runtime
		// error, dropping us into the debugger.
		action() {
			foozle += 1;
			inherited();
		}
	}
;

gameMain: GameMainDef initialPlayerChar = me;
