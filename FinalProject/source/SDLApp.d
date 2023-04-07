// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import Surface : Surface;
import Surface : Color;

class SDLApp {

    this() {
        InitializeSDL();
    }

    ~this() {
        SDL_Quit();
        writeln("Ending application--good bye!");
    }

    void InitializeSDL() {
        SDLSupport ret;

        version(Windows){
            writeln("Searching for SDL on Windows");
            ret = loadSDL("SDL2.dll");
        }
        version(OSX){
            writeln("Searching for SDL on Mac");
            ret = loadSDL();
        }
        version(linux){
            writeln("Searching for SDL on Linux");
            ret = loadSDL();
        }

        // Error if SDL cannot be loaded
        if(ret != sdlSupport){
            writeln("error loading SDL library");

            foreach( info; loader.errors){
                writeln(info.error,':', info.message);
            }
        }
        if(ret == SDLSupport.noLibrary){
            writeln("error no library found");
        }
        if(ret == SDLSupport.badLibrary){
            writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?");
        }

        // Initialize SDL
        if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
            writeln("SDL_Init: ", fromStringz(SDL_GetError()));
        }
    }

    void MainApplicationLoop() {
        Surface mySurface = new Surface();
        Surface windowSurface = SDL_GetWindowSurface(mySurface.getWindow());

        // Flag for determing if we are running the main application loop
        bool runApplication = true;
        // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
        //                                                but not yet released)
        bool drawing = false;

        // Main application loop that will run until a quit event has occurred.
        // This is the 'main graphics loop'
        while(runApplication){
            SDL_Event e;
            // Handle events
            // Events are pushed into an 'event queue' internally in SDL, and then
            // handled one at a time within this loop for as many events have
            // been pushed into the internal SDL queue. Thus, we poll until there
            // are '0' events or a NULL event is returned.
            while(SDL_PollEvent(&e) !=0){
                if(e.type == SDL_QUIT){
                    runApplication= false;
                }
                else if(e.type == SDL_MOUSEBUTTONDOWN){
                    if (e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 80 && e.button.y >= 0 && e.button.y <= 60) {
                        mySurface.IncreaseBrushSize();
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 80 && e.button.y > 60 && e.button.y <= 120) {
                        mySurface.DecreaseBrushSize();
                    } else {
                        drawing=true;
                    }
                    
                }else if(e.type == SDL_MOUSEBUTTONUP){
                    drawing=false;
                }else if(e.type == SDL_MOUSEMOTION && drawing){
                    // retrieve the position
                    int xPos = e.button.x;
                    int yPos = e.button.y;
                    // Loop through and update specific pixels
                    // NOTE: No bounds checking performed --
                    //       think about how you might fix this :)
                    int brushSize=mySurface.getBrushSize();
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            mySurface.UpdateSurfacePixel(xPos+w,yPos+h);
                        }
                    }
                } else if(e.type == SDL_KEYDOWN) {
                    if (e.key.keysym.sym == SDLK_UP) {
                        mySurface.IncreaseBrushSize();
                    } else if (e.key.keysym.sym == SDLK_DOWN) {
                        mySurface.DecreaseBrushSize();
                    } else if (e.key.keysym.sym == SDLK_LEFT) {
                        mySurface.nextColor();
                    } else if (e.key.keysym.sym == SDLK_RIGHT) {
                        mySurface.previousColor();
                    } else if (e.key.keysym.sym == SDLK_SPACE) {
                        mySurface.ClearSurface();
                    }
                }
            }
            mySurface.BlitSurface();
        }
        mySurface.DestroyWindow();
    }
}