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
    }

    ~this() {
        scope(exit) {
            SDL_FreeSurface(imgSurface);
        }
    }

    /// Function for updating the pixels in a surface to a 'blue-ish' color.
    void UpdateSurfacePixel(int xPos, int yPos, Color* color){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(imgSurface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0] = color.b;
        // Change the 'green' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1] = color.g;
        // Change the 'red' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2] = color.r;
    }

    int GetRed(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0];
    }

    int GetGreen(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1];
    }

    int GetBlue(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2];
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
}