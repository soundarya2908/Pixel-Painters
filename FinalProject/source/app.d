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

	SDL_Window* window = SDL_CreateWindow("D SDL Painting",SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,800,700,SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);

	SDLApp myApp = new SDLApp(hostName, port,window, runStandaloneMode);
	myApp.MainApplicationLoop();
}
