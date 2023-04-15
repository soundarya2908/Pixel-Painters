import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

@("testing that a pixel is black by default")
unittest{
    SDLApp app = new SDLApp("localhost", 50002);
    app.InitializeSDL();
    Surface surface = new Surface();

    assert(surface.getRed(100, 100) == 50);
    assert(surface.getGreen(100, 100) == 50);
    assert(surface.getBlue(100, 100) == 50);
}