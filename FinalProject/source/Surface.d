// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import std.stdio;

struct Color {
    ubyte r;
    ubyte g;
    ubyte b;
}

class Surface {
    SDL_Surface* imgSurface;
    SDL_Window* window;
    private Color color;
    private int brushSize;

    this() {
        // Create an SDL window
        window= SDL_CreateWindow("D SDL Painting",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        640,
        480,
        SDL_WINDOW_SHOWN);
        // Load the bitmap surface
        imgSurface = SDL_CreateRGBSurface(0,640,480,32,0,0,0,0);
        color = Color(255,255,255);
        setMediumBrush();
    }

    ~this() {
        scope(exit) {
            SDL_FreeSurface(imgSurface);
        }
    }

    void BlitSurface() {
        // Blit the surace (i.e. update the window with another surfaces pixels
        //                       by copying those pixels onto the window).
        SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
        // Update the window surface
        SDL_UpdateWindowSurface(window);
        // Delay for 16 milliseconds
        // Otherwise the program refreshes too quickly
        SDL_Delay(16);
    }

    void DestroyWindow() {
        SDL_DestroyWindow(window);
    }

    void UpdateSurfacePixel(int xPos, int yPos){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(imgSurface);

        //TODO: delete when done testing
        setColorRed();

        Color color = getColor();

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0] = color.b;
        // Change the 'green' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1] = color.g;
        // Change the 'red' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2] = color.r;
    }

    int getRed(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0];
    }

    int getGreen(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1];
    }

    int getBlue(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2];
    }

    int GetBrushSize() {
        return brushSize;
    }

    void setBrushSize(int size) {
        brushSize = size;
    }

    Color getColor() {
        return color;
    }

    void setColor(Color* color) {
        this.color = *color;
    }

    //These functions will be linked to buttons in the UI
    void setColorOrange() {
        setColor(new Color(255,165,0));
    }

    void setColorPurple() {
        setColor(new Color(128,0,128));
    }

    void setColorGreen() {
        setColor(new Color(124,252,0));
    }

    void setColorBlue() {
        setColor(new Color(0,0,255));
    }

    void setColorRed() {
        setColor(new Color(255,0,0));
    }

    void setEraser() {
        setColor(new Color(0,0,0));
    }

    void setSmallBrush() {
        setBrushSize(2);
    }

    void setMediumBrush() {
        setBrushSize(4);
    }

    void setLargeBrush() {
        setBrushSize(8);
    }
}