import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing that a eraser works")
unittest{
    SDLApp app = new SDLApp("localhost", 50002,null, true);
    app.InitializeSDL();
    Surface surface = new Surface();

    surface.setColorOrange();
    surface.UpdateSurfacePixel(100, 100);
    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);

    surface.setEraser();
    surface.UpdateSurfacePixel(100, 100);
    assert(surface.getRed(100, 100) == 50);
    assert(surface.getGreen(100, 100) == 50);
    assert(surface.getBlue(100, 100) == 50);
}
