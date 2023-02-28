#charset "us-ascii"
//
// noninterative.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple non-interactive test of the debugTools stack trace and
// breakpoint functionality.
//
// It can be compiled via the included makefile with
//
//	# t3make -f noninterative.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <advlite.h>

versionInfo:    GameID;

class Foo: object prop = nil;
foo: Foo prop = 'foo';
bar: Foo prop = 'bar';
baz: Foo prop = 'baz';

+me: Thing
	isFixed = true
	proper = true
	ownsContents = true
	person = 2
	contType = Carrier
;

gameMain:       GameMainDef
	initialPlayerChar = me
	newGame() {
		local foo, bar;

		// Set some variables for the stack trace to output
		foo = 123;
		bar = '[This space intentionally left blank]';

		// Kludge so the compiler won't complain that we defined
		// variables that aren't used.
		if(foo) {}
		if(bar) {}

		"<.p>This is some placeholder text that comes before the
			breakpoint.<.p> ";

		// Set a "breakpoint".
		__debugTool.breakpoint();

		"<.p>This is some placeholder text that comes after the
			breakpoint.<.p> ";
	}
;
