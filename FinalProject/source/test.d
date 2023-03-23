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
    SDLApp app = new SDLApp();
    app.InitializeSDL();

    Surface surface = new Surface();

    assert(surface.GetRed(50, 50) == 0);
    assert(surface.GetGreen(50, 50) == 0);
    assert(surface.GetBlue(50, 50) == 0);
}

@("testing that a colored pixel is the correct color")
unittest{
    SDLApp app = new SDLApp();
    app.InitializeSDL();

    Surface surface = new Surface();

    surface.UpdateSurfacePixel(50, 50);

    assert(surface.GetRed(50, 50) == 255);
    assert(surface.GetGreen(50, 50) == 128);
    assert(surface.GetBlue(50, 50) == 32);
}

@("testing that a drawn pixel updates to the correct color")
unittest{
    SDLApp app = new SDLApp();
    app.InitializeSDL();

    Surface surface = new Surface();

    assert(surface.GetRed(50, 50) == 0);
    assert(surface.GetGreen(50, 50) == 0);
    assert(surface.GetBlue(50, 50) == 0);

    surface.UpdateSurfacePixel(50, 50);

    assert(surface.GetRed(50, 50) == 255);
    assert(surface.GetGreen(50, 50) == 128);
    assert(surface.GetBlue(50, 50) == 32);
}