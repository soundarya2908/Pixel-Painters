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
	string hostName = userInput.ValidatedHostNameInput();
	ushort port = userInput.ValidatedPortInput();
	bool runStandaloneMode = false;
	runStandaloneMode = userInput.ValidateUserInput();

	SDLApp myApp = new SDLApp(hostName, port, runStandaloneMode);
	myApp.MainApplicationLoop();
}
