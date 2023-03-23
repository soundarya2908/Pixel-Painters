/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

// global variable for sdl;
const SDLSupport ret;

import SDLApp : SDLApp;

// Entry point to program
void main()
{
	SDLApp myApp = new SDLApp();
	myApp.MainApplicationLoop();
}
