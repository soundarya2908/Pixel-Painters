/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import std.conv;

// global variable for sdl;
const SDLSupport ret;
import UserInput: UserInput;

import SDLApp : SDLApp;

// Entry point to program
void main()
{
	auto userInput = new UserInput();
	string hostName = userInput.ValidatedHostNameInput();
	ushort port = userInput.ValidatedPortInput();
	bool runStandaloneMode = false;
	runStandaloneMode = userInput.ValidateUserInput();

	SDLApp myApp = new SDLApp(hostName, port, false, runStandaloneMode);
	myApp.MainApplicationLoop();
}
