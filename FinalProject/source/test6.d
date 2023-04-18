import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing different brush size")
unittest{

    SDLApp app = new SDLApp("localhost", 50002, true, true);
    app.InitializeSDL();
    Surface surface = app.GetSurface();
    int brushSize = 6;

    surface.setColorOrange();
    surface.setBrushSize(brushSize);
    int xPos = 100;
    int yPos = 100;
    app.Draw(xPos,yPos, brushSize, false, false);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(95, 95) == 255);
    assert(surface.getGreen(95, 95) == 165);
    assert(surface.getBlue(95, 95) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(96, 96) == 255);
    assert(surface.getGreen(96, 96) == 165);
    assert(surface.getBlue(96, 96) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(97, 97) == 255);
    assert(surface.getGreen(97, 97) == 165);
    assert(surface.getBlue(97, 97) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(98, 98) == 255);
    assert(surface.getGreen(98, 98) == 165);
    assert(surface.getBlue(98, 98) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(99, 99) == 255);
    assert(surface.getGreen(99, 99) == 165);
    assert(surface.getBlue(99, 99) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);

    brushSize = 2;
    surface.setBrushSize(brushSize);
    xPos = 300;
    yPos = 300;
    app.Draw(xPos,yPos, brushSize, false, false);

    //color pixel outside range of brush size remians unpainted
    assert(surface.getRed(297, 297) == 50);
    assert(surface.getGreen(297, 297) == 50);
    assert(surface.getBlue(297, 297) == 50);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(299, 299) == 255);
    assert(surface.getGreen(299, 299) == 165);
    assert(surface.getBlue(299, 299) == 0);

    //color pixel inside range of brush size gets painted
    assert(surface.getRed(300, 300) == 255);
    assert(surface.getGreen(300, 300) == 165);
    assert(surface.getBlue(300, 300) == 0);

}
