import Surface : Surface;
import SDLApp : SDLApp;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


// @("testing that a pixel's default color'")
// unittest{
//     SDLApp app = new SDLApp("localhost", 50002);
//     app.InitializeSDL();
//     Surface surface = new Surface();
//     assert(surface.getRed(100, 100) == 50);
//     assert(surface.getGreen(100, 100) == 50);
//     assert(surface.getBlue(100, 100) == 50);
// }

// @("testing that a colored pixel is the correct color")
// unittest{
//     SDLApp app = new SDLApp("localhost", 50002);
//     app.InitializeSDL();
//     Surface surface = new Surface();

//     //orange color
//     surface.setColorOrange();
//     surface.UpdateSurfacePixel(100, 100);
//     assert(surface.getRed(100, 100) == 255);
//     assert(surface.getGreen(100, 100) == 165);
//     assert(surface.getBlue(100, 100) == 0);

//     //black color
//     surface.setColorBlack();
//     surface.UpdateSurfacePixel(50, 50);
//     assert(surface.getRed(50, 50) == 255);
//     assert(surface.getGreen(50, 50) == 255);
//     assert(surface.getBlue(50, 50) == 255);

//     //white color
//     surface.setColorWhite();
//     surface.UpdateSurfacePixel(54, 54);
//     assert(surface.getRed(54, 54) == 0);
//     assert(surface.getGreen(54, 54) == 0);
//     assert(surface.getBlue(54, 54) == 0);

//     //purple color
//     surface.setColorPurple();
//     surface.UpdateSurfacePixel(56, 56);
//     assert(surface.getRed(56, 56) == 128);
//     assert(surface.getGreen(56, 56) == 0);
//     assert(surface.getBlue(56, 56) == 128);

//     //green color
//     surface.setColorGreen();
//     surface.UpdateSurfacePixel(58, 58);
//     assert(surface.getRed(58, 58) == 124);
//     assert(surface.getGreen(58, 58) == 252);
//     assert(surface.getBlue(58, 58) == 0);

//     //blue color
//     surface.setColorBlue();
//     surface.UpdateSurfacePixel(60, 60);
//     assert(surface.getRed(60, 60) == 0);
//     assert(surface.getGreen(60, 60) == 0);
//     assert(surface.getBlue(60, 60) == 255);

//     //red color
//     surface.setColorRed();
//     surface.UpdateSurfacePixel(62, 62);
//     assert(surface.getRed(100, 100) == 255);
//     assert(surface.getGreen(100, 100) == 0);
//     assert(surface.getBlue(100, 100) == 0);

// }

@("testing that a drawn pixel updates to the correct color")
unittest{
    SDLApp app = new SDLApp("localhost", 50002);
    app.InitializeSDL();
    Surface surface = new Surface();

    assert(surface.getRed(50, 50) == 0);
    assert(surface.getGreen(50, 50) == 0);
    assert(surface.getBlue(50, 50) == 0);

    surface.UpdateSurfacePixel(50, 50);

    assert(surface.getRed(50, 50) == 255);
    assert(surface.getGreen(50, 50) == 128);
    assert(surface.getBlue(50, 50) == 32);
}