module Surface;
// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import std.stdio;

/**
 * This is a struct created to hold the color information for the pixels
 * in the surface. It is used to set the color of the brush.
 */
struct Color {
    ubyte r;
    ubyte g;
    ubyte b;
}

/**
 * This is a class that will hold the SDL_Surface and the color information.
 * It will also have functions to modify the pixels in the surface.
 */
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

    /**
     * This function updates the particular pixel in the surface.
     * It takes the x and y coordinates of the pixel as parameters, 
     * calculates the pixel to be updated and updates the pixel.
     */
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

    /**
     * This method returns the red component of the pixel at the given coordinates.
     */
    int getRed(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2];
    }

    /**
     * This method returns the green component of the pixel at the given coordinates.
     */
    int getGreen(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1];
    }

    /**
     * This method returns the blue component of the pixel at the given coordinates.
     */
    int getBlue(int xPos, int yPos) {
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        return pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0];
    }

    /**
     * This method returns the brush color that is set at the moment in the application.
     */
    Color getColor() {
        return color;
    }

    /**
     * This method sets the brush color depending on the parameters passed.
     */
    void setColor(Color* color) {
        this.color = *color;
    }

    /**
     * This method gets the size of the brush.
     */
    int getBrushSize() {
        return brushSize;
    }

    /**
     * This method sets the size of the brush.
     */
    void setBrushSize(int size) {
        brushSize = size;
    }

    /**
     * This method sets the color of the brush to orange.
     */
    void setColorOrange() {
        setColor(new Color(255,165,0));
    }

    /**
     * This method sets the color of the brush to black.
     */
    void setColorBlack() {
        setColor(new Color(0,0,0));
    }

    /**
     * This method sets the color of the brush to white.
     */
    void setColorWhite() {
        setColor(new Color(255,255,255));
    }

    /**
     * This method sets the color of the brush to purple.
     */
    void setColorPurple() {
        setColor(new Color(128,0,128));
    }

    /**
     * This method sets the color of the brush to green.
     */
    void setColorGreen() {
        setColor(new Color(124,252,0));
    }

    /**
     * This method sets the color of the brush to blue.
     */
    void setColorBlue() {
        setColor(new Color(0,0,255));
    }

    /**
     * This method sets the color of the brush to red.
     */
    void setColorRed() {
        setColor(new Color(255,0,0));
    }

    /**
     * This method sets the color of the brush to yellow.
     */
    void setEraser() {
        setColor(new Color(50,50,50));
    }

    /**
     * This method increases the size of the brush by 2.
     */
    void IncreaseBrushSize() {
        if (getBrushSize() < 16) {
            setBrushSize(getBrushSize() + 2);
        } else {
            setBrushSize(16);
        }
    }

    /**
     * This method decreases the size of the brush by 2.
     */
    void DecreaseBrushSize() {
        if (getBrushSize() > 2) {
            setBrushSize(getBrushSize() - 2);
        } else {
            setBrushSize(2);
        }
    }

    /**
     * This method changes the color of the brush to the next color in the list.
     */
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

    /**
     * This method changes the color of the brush to the previous color in the list.
     */
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

    /**
     * This method clears the surface.
     */
    void ClearSurface() {
        SDL_Rect* rect = new SDL_Rect(50,0,750,700);
        SDL_FillRect(imgSurface,rect,SDL_MapRGB(imgSurface.format,50,50,50));
    }
}