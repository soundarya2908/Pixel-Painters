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
    SDLApp app = new SDLApp("localhost", 50002, true, true);
    app.InitializeSDL();
    Surface surface = new Surface();

    surface.setColorOrange();
    surface.UpdateSurfacePixel(100, 100);
    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);

    surface.setColorBlack();
    surface.UpdateSurfacePixel(102, 102);
    assert(surface.getRed(102, 102) == 0);
    assert(surface.getGreen(102, 102) == 0);
    assert(surface.getBlue(102, 102) == 0);

    surface.setColorWhite();
    surface.UpdateSurfacePixel(104, 104);
    assert(surface.getRed(104, 104) == 255);
    assert(surface.getGreen(104, 104) == 255);
    assert(surface.getBlue(104, 104) == 255);

    surface.setColorPurple();
    surface.UpdateSurfacePixel(106, 106);
    assert(surface.getRed(106, 106) == 128);
    assert(surface.getGreen(106, 106) == 0);
    assert(surface.getBlue(106, 106) == 128);

    surface.setColorGreen();
    surface.UpdateSurfacePixel(108, 108);
    assert(surface.getRed(108, 108) == 124);
    assert(surface.getGreen(108, 108) == 252);
    assert(surface.getBlue(108, 108) == 0);

    surface.setColorBlue();
    surface.UpdateSurfacePixel(110, 110);
    assert(surface.getRed(110, 110) == 0);
    assert(surface.getGreen(110, 110) == 0);
    assert(surface.getBlue(110, 110) == 255);

    surface.setColorRed();
    surface.UpdateSurfacePixel(112, 112);
    assert(surface.getRed(112, 112) == 255);
    assert(surface.getGreen(112, 112) == 0);
    assert(surface.getBlue(112, 112) == 0);
}
