module app;

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

/**
    The following is an entry point to the program. 

	The program will ask the user for the host name and port number while running the server.
	The program then creates an SDLApp and runs the main application loop.
    
*/
void main()
{

	auto userInput = new UserInput();
	bool runStandaloneMode = false;
	runStandaloneMode = userInput.ValidateUserInput();
	string hostName="localhost";
	ushort port = 50002;
	if(!runStandaloneMode) {
		hostName = userInput.ValidatedHostNameInput();
		port = userInput.ValidatedPortInput();
	}

	SDLApp myApp = new SDLApp(hostName, port, false, runStandaloneMode);
	myApp.MainApplicationLoop();
}
