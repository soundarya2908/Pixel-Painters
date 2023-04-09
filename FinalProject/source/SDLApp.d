// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import Surface : Surface;
import Surface : Color;
import std.socket;
import std.stdio;
import Packet:Packet;
import std.conv;
import core.thread;

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
        auto socket = new Socket(AddressFamily.INET, SocketType.STREAM);
        // Socket needs an 'endpoint', so we determine where we
        // are going to connect to.
        // NOTE: It's possible the port number is in use if you are not
        //       able to connect. Try another one.
        socket.connect(new InternetAddress("localhost", 50002));
        scope(exit) socket.close();
        writeln("Connected");

        // Flag for determing if we are running the main application loop
        bool runApplication = true;
        // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
        //                                                but not yet released)
        bool drawing = false;

        auto serverReader = new Thread(() {
            char[Packet.sizeof] receiveBuffer;
            while (runApplication) {
                // Read data from socket
                long bytesReceived = socket.receive(receiveBuffer);
                if (bytesReceived > 0) {
                    auto fromServer = receiveBuffer[0 .. bytesReceived];

                    // Format the packet. Note, I am doing this in a very
                    // verbosoe manner so you can see each step.
                    Packet formattedPacket;
                    formattedPacket = Packet.getPacketFromBytes(receiveBuffer,Packet.sizeof);
                    writeln(formattedPacket);
                    writeln(formattedPacket.x);
                    writeln(formattedPacket.y);
                    if (formattedPacket.x < 0 || formattedPacket.x >= 640 ||
                    formattedPacket.y < 0 || formattedPacket.y >= 480) {
                        writeln("Invalid pixel coordinates: ", formattedPacket.x, ", ", formattedPacket.y);
                    } else {
                        mySurface.UpdateSurfacePixel(formattedPacket.x, formattedPacket.y);
                    }
                }
            }
        });

        // Start the server reader thread
        serverReader.start();


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
                    if (e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y >= 0 && e.button.y <= 50) {
                        mySurface.IncreaseBrushSize();
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 102 && e.button.y <= 152) {
                        mySurface.DecreaseBrushSize();
                    } 
                    
                    else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 201 && e.button.y <= 251) {
                        mySurface.setColorBlack(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 252 && e.button.y <= 302) {
                        mySurface.setColorWhite(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 303 && e.button.y <= 353) {
                        mySurface.setColorBlue(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 354 && e.button.y <= 404) {
                        mySurface.setColorPurple(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 405 && e.button.y <= 455) {
                        mySurface.setColorGreen(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 456 && e.button.y <= 506) {
                        mySurface.setColorOrange(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 507 && e.button.y <= 557) {
                        mySurface.setColorRed(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 599 && e.button.y <= 649) {
                        mySurface.setEraser(); 
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 650 && e.button.y <= 700) {
                        mySurface.ClearSurface(); 
                    }
                    
                    else {
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
                            Packet dataToSend;
                            // The 'with' statement allows us to access an object
                            // (i.e. member variables and member functions)
                            // in a slightly more convenient way
                            with (dataToSend){
                                user = "clientName\0";
                                // Just some 'dummy' data for now
                                // that the 'client' will continuously send
                                x = xPos;
                                y = yPos;
                                r = 49;
                                g = 50;
                                b = 51;
                                message = "test\0";
                            }
                            // Send the packet of information
                            socket.send(dataToSend.GetPacketAsBytes());
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