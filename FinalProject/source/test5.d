import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


@("testing different eraser size")
unittest{

    SDLApp app = new SDLApp("localhost", 50002, true, true);
    app.InitializeSDL();
    Surface surface = app.GetSurface();
    int brushSize = 6;

    surface.setColorOrange();
    surface.setBrushSize(brushSize);
    int xPos = 100;
    int yPos = 100;
    //first draw with orange color
    app.Draw(xPos,yPos, brushSize, false, false);

    assert(surface.getRed(95, 95) == 255);
    assert(surface.getGreen(95, 95) == 165);
    assert(surface.getBlue(95, 95) == 0);

    assert(surface.getRed(96, 96) == 255);
    assert(surface.getGreen(96, 96) == 165);
    assert(surface.getBlue(96, 96) == 0);

    assert(surface.getRed(97, 97) == 255);
    assert(surface.getGreen(97, 97) == 165);
    assert(surface.getBlue(97, 97) == 0);

    assert(surface.getRed(98, 98) == 255);
    assert(surface.getGreen(98, 98) == 165);
    assert(surface.getBlue(98, 98) == 0);

    assert(surface.getRed(99, 99) == 255);
    assert(surface.getGreen(99, 99) == 165);
    assert(surface.getBlue(99, 99) == 0);

    assert(surface.getRed(100, 100) == 255);
    assert(surface.getGreen(100, 100) == 165);
    assert(surface.getBlue(100, 100) == 0);


    int eraserBrushSize = 2;
    surface.setBrushSize(eraserBrushSize);
    surface.setEraser();
    xPos = 100;
    yPos = 100;
    app.Draw(xPos,yPos, eraserBrushSize, false, false);

    //pixel still stays colored
    assert(surface.getRed(95, 95) == 255);
    assert(surface.getGreen(95, 95) == 165);
    assert(surface.getBlue(95, 95) == 0);

    //pixel still stays colored
    assert(surface.getRed(96, 96) == 255);
    assert(surface.getGreen(96, 96) == 165);
    assert(surface.getBlue(96, 96) == 0);

    //pixel clears as eraser size was 2
    assert(surface.getRed(99, 99) == 50);
    assert(surface.getGreen(99, 99) == 50);
    assert(surface.getBlue(99, 99) == 50);

    //pixel clears as eraser size was 2
    assert(surface.getRed(100, 100) == 50);
    assert(surface.getGreen(100, 100) == 50);
    assert(surface.getBlue(100, 100) == 50);
}
