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
    private Color color;
    private int brushSize;

    this() {
        // Load the bitmap surface
        imgSurface = SDL_CreateRGBSurface(0,800,700,32,0,0,0,0);
        SDL_FillRect(imgSurface,null,SDL_MapRGB(imgSurface.format,50,50,50));
        color = Color(255,255,255);
        setBrushSize(6);
    }

    ~this() {
        scope(exit) {
            SDL_FreeSurface(imgSurface);
        }
    }

    void UpdateSurfacePixel(int xPos, int yPos){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(imgSurface);

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
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2];
    }

    int getGreen(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1];
    }

    int getBlue(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0];
    }

    Color getColor() {
        return color;
    }

    void setColor(Color* color) {
        this.color = *color;
    }

    int getBrushSize() {
        return brushSize;
    }

    void setBrushSize(int size) {
        brushSize = size;
    }

    //These functions will be linked to buttons in the UI
    void setColorOrange() {
        setColor(new Color(255,165,0));
    }

    void setColorBlack() {
        setColor(new Color(0,0,0));
    }

    void setColorWhite() {
        setColor(new Color(255,255,255));
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
        setColor(new Color(50,50,50));
    }

    void IncreaseBrushSize() {
        if (getBrushSize() < 16) {
            setBrushSize(getBrushSize() + 2);
        } else {
            setBrushSize(16);
        }
    }

    void DecreaseBrushSize() {
        if (getBrushSize() > 2) {
            setBrushSize(getBrushSize() - 2);
        } else {
            setBrushSize(2);
        }
    }

    //TODO: maybe worth making this a switch statement and creating predefined color structs
    void nextColor() {
        if (getColor().r == 255 && getColor().g == 255 && getColor().b == 255) {
            setColorOrange();
        } else if (getColor().r == 255 && getColor().g == 165 && getColor().b == 0) {
            setColorPurple();
        } else if (getColor().r == 128 && getColor().g == 0 && getColor().b == 128) {
            setColorGreen();
        } else if (getColor().r == 124 && getColor().g == 252 && getColor().b == 0) {
            setColorBlue();
        } else if (getColor().r == 0 && getColor().g == 0 && getColor().b == 255) {
            setColorRed();
        } else if (getColor().r == 255 && getColor().g == 0 && getColor().b == 0) {
            setEraser();
        } else if (getColor().r == 0 && getColor().g == 0 && getColor().b == 0) {
            setColor(new Color(255,255,255));
        }
    }

    void previousColor() {
        if (getColor().r == 255 && getColor().g == 255 && getColor().b == 255) {
            setEraser();
        } else if (getColor().r == 255 && getColor().g == 165 && getColor().b == 0) {
            setColor(new Color(255,255,255));
        } else if (getColor().r == 128 && getColor().g == 0 && getColor().b == 128) {
            setColorOrange();
        } else if (getColor().r == 124 && getColor().g == 252 && getColor().b == 0) {
            setColorPurple();
        } else if (getColor().r == 0 && getColor().g == 0 && getColor().b == 255) {
            setColorGreen();
        } else if (getColor().r == 255 && getColor().g == 0 && getColor().b == 0) {
            setColorBlue();
        } else if (getColor().r == 0 && getColor().g == 0 && getColor().b == 0) {
            setColorRed();
        }
    }

    void ClearSurface() {
        SDL_Rect* rect = new SDL_Rect(50,0,750,700);
        SDL_FillRect(imgSurface,rect,SDL_MapRGB(imgSurface.format,50,50,50));
    }
}