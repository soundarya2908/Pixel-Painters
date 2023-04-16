import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing that a colored pixel is the correct color")
unittest{
    SDLApp app = new SDLApp("localhost", 50002, true);
    app.InitializeSDL();
    Surface surface = new Surface();
    surface.setColorOrange();
    surface.UpdateSurfacePixel(100, 100);

    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);
}

/*

@("testing that a colored pixel is the correct color")
unittest{
    Surface surface = new Surface();

    surface.UpdateSurfacePixel(50, 50);

    assert(surface.getRed(50, 50) == 255);
    assert(surface.getGreen(50, 50) == 128);
    assert(surface.getBlue(50, 50) == 32);
}

@("testing that a drawn pixel updates to the correct color")
unittest{
    Surface surface = new Surface();

    assert(surface.getRed(50, 50) == 0);
    assert(surface.getGreen(50, 50) == 0);
    assert(surface.getBlue(50, 50) == 0);

    surface.UpdateSurfacePixel(50, 50);

    assert(surface.getRed(50, 50) == 255);
    assert(surface.getGreen(50, 50) == 128);
    assert(surface.getBlue(50, 50) == 32);
}
*/
