import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing that app does not allow to paint over the tool box pixels")
unittest{
    SDLApp app = new SDLApp("localhost", 50002, true, true);
    app.InitializeSDL();
    Surface surface = app.GetSurface();

    surface.setColorOrange();
    app.Draw(100, 100, 5, false, false);

    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);

    app.Draw(10, 10, 5, false, false);
    assert(surface.getRed(10, 10) != 255);
    assert(surface.getGreen(10, 10) != 165);
    assert(surface.getBlue(10, 10) != 0);
}
