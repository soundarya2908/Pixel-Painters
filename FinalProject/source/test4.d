import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing that clear screen works")
unittest{
    SDLApp app = new SDLApp("localhost", 50002, true);
    app.InitializeSDL();
    Surface surface = new Surface();

    surface.setColorOrange();
    surface.UpdateSurfacePixel(100, 100);
    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);
    surface.UpdateSurfacePixel(101, 101);
    assert(surface.getRed(101, 101) == 255);
    assert(surface.getGreen(101, 101) == 165);
    assert(surface.getBlue(101, 101) == 0);
    surface.UpdateSurfacePixel(102, 102);
    assert(surface.getRed(102, 102) == 255);
    assert(surface.getGreen(102, 102) == 165);
    assert(surface.getBlue(102, 102) == 0);
    surface.UpdateSurfacePixel(103, 103);
    assert(surface.getRed(103, 103) == 255);
    assert(surface.getGreen(103, 103) == 165);
    assert(surface.getBlue(103, 103) == 0);
    surface.UpdateSurfacePixel(104, 104);
    assert(surface.getRed(104, 104) == 255);
    assert(surface.getGreen(104, 104) == 165);
    assert(surface.getBlue(104, 104) == 0);
    surface.UpdateSurfacePixel(105, 105);
    assert(surface.getRed(105, 105) == 255);
    assert(surface.getGreen(105, 105) == 165);
    assert(surface.getBlue(105, 105) == 0);
    surface.UpdateSurfacePixel(106, 106);
    assert(surface.getRed(106, 106) == 255);
    assert(surface.getGreen(106, 106) == 165);
    assert(surface.getBlue(106, 106) == 0);
    surface.UpdateSurfacePixel(107, 107);
    assert(surface.getRed(107, 107) == 255);
    assert(surface.getGreen(107, 107) == 165);
    assert(surface.getBlue(107, 107) == 0);
    surface.UpdateSurfacePixel(108, 108);
    assert(surface.getRed(108, 108) == 255);
    assert(surface.getGreen(108, 108) == 165);
    assert(surface.getBlue(108, 108) == 0);
    surface.UpdateSurfacePixel(109, 109);
    assert(surface.getRed(109, 109) == 255);
    assert(surface.getGreen(109, 109) == 165);
    assert(surface.getBlue(109, 109) == 0);

    surface.ClearSurface();

    assert(surface.getRed(100, 100) == 50);
    assert(surface.getGreen(100, 100) == 50);
    assert(surface.getBlue(100, 100) == 50);
    // assert(surface.getRed(101, 101) == 50);
    // assert(surface.getGreen(101, 101) == 50);
    // assert(surface.getBlue(101, 101) == 50);
    // assert(surface.getRed(102, 102) == 50);
    // assert(surface.getGreen(102, 102) == 50);
    // assert(surface.getBlue(102, 102) == 50);
    // assert(surface.getRed(103, 103) == 50);
    // assert(surface.getGreen(103, 103) == 50);
    // assert(surface.getBlue(103, 103) == 50);
    // assert(surface.getRed(104, 104) == 50);
    // assert(surface.getGreen(104, 104) == 50);
    // assert(surface.getBlue(104, 104) == 50);
    // assert(surface.getRed(105, 105) == 50);
    // assert(surface.getGreen(105, 105) == 50);
    // assert(surface.getBlue(105, 105) == 50);
    // assert(surface.getRed(106, 106) == 50);
    // assert(surface.getGreen(106, 106) == 50);
    // assert(surface.getBlue(106, 106) == 50);
    // assert(surface.getRed(107, 107) == 50);
    // assert(surface.getGreen(107, 107) == 50);
    // assert(surface.getBlue(107, 107) == 50);
    // assert(surface.getRed(108, 108) == 50);
    // assert(surface.getGreen(108, 108) == 50);
    // assert(surface.getBlue(108, 108) == 50);
    assert(surface.getRed(109, 109) == 50);
    assert(surface.getGreen(109, 109) == 50);
    assert(surface.getBlue(109, 109) == 50);


}
