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
    private:
        Surface mySurface;
        Socket serverSocket;
        SDL_Window* window;
        Packet[] packetHistory;
        Packet[] undoStack;
        Packet[] redoStack;
        bool runInStandAloneMode;
        static bool isSDLLoaded;

    public:
        this(string serverHost, ushort serverPort, bool test, bool runStandalone) {
            InitializeSDL();
            mySurface = new Surface();
            runInStandAloneMode = runStandalone;
            if(!runInStandAloneMode) {
                serverSocket = new Socket(AddressFamily.INET, SocketType.STREAM);
                serverSocket.connect(new InternetAddress(serverHost,serverPort));
                writeln("Connected to the Server");
            } else{
                writeln("Running the app in Standalone mode");
            }
            if(test) {
                window = null;
            } else {
                window = SDL_CreateWindow("D SDL Painting",SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,800,700,SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
                SDL_UpdateWindowSurface(window);
            }
            undoStack = new Packet[0];
            redoStack = new Packet[0];
            initSurface();
        }

        ~this() {
            SDL_Quit();
            writeln("Ending application--good bye!");
        }

    static synchronized void InitializeSDL() {
        if(isSDLLoaded) {
            return;
        }

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
        isSDLLoaded = true;
    }

    void MainApplicationLoop() {
        // Flag for determing if we are running the main application loop
        bool runApplication = true;
        // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
        //                                                but not yet released)
        bool drawing = false;

        if(!runInStandAloneMode) {
            refreshClientScreen();
        }

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
                else if(e.type == SDL_MOUSEBUTTONDOWN) {
                    if (e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y >= 0 && e.button.y <= 50) {
                        mySurface.IncreaseBrushSize();
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 102 && e.button.y <= 152) {
                        mySurface.DecreaseBrushSize();
                    } else if(e.button.button == SDL_BUTTON_LEFT && e.button.x >= 0 && e.button.x <= 50 && e.button.y > 201 && e.button.y <= 251) {
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
                        if(!runInStandAloneMode) {
                            Packet dataToSend = getPacketData(-1,-1, 3, "reset\0");
                            // Send the packet of information
                            serverSocket.send(dataToSend.GetPacketAsBytes());
                        }
                        undoStack = new Packet[0];
                    } else {
                        drawing=true;
                    }
                } else if(e.type == SDL_MOUSEBUTTONUP){
                    drawing=false;
                } else if(e.type == SDL_MOUSEMOTION && drawing){
                    // retrieve the position
                    int xPos = e.button.x;
                    int yPos = e.button.y;
                    int brshSize=mySurface.getBrushSize();

                    if(xPos > 55) {
                        Draw(xPos, yPos, brshSize, true, false);
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
                        if(!runInStandAloneMode) {
                            Packet dataToSend = getPacketData(-1,-1, 3, "reset\0");
                            // Send the packet of information
                            serverSocket.send(dataToSend.GetPacketAsBytes());
                        }
                        undoStack = new Packet[0];
                    } else if (e.key.keysym.sym == SDLK_u && SDL_GetModState() & KMOD_CTRL) {
                        undo();
                    } else if (e.key.keysym.sym == SDLK_r && SDL_GetModState() & KMOD_CTRL) {
                        redo();
                    }
                }
            }
            if(window != null) {
                BlitSurface();
            }
        }
        DestroyWindow();
    }

    void Draw(int xPos, int yPos,int brshSize, bool sendData, bool undoing) {
        // Loop through and update specific pixels
        // NOTE: No bounds checking performed --
        //       think about how you might fix this :)
        for(int w=-brshSize; w < brshSize; w++){
            for(int h=-brshSize; h < brshSize; h++){
                mySurface.UpdateSurfacePixel(xPos+w,yPos+h);
                if(sendData & !runInStandAloneMode) {
                    Packet dataToSend = getPacketData(xPos, yPos, brshSize, "test90");
                    // Send the packet of information
                    serverSocket.send(dataToSend.GetPacketAsBytes());
                    if (!undoing) {
                        undoStack ~= dataToSend;
                    }
                }
            }
        }
    }

    Packet getPacketData(int xPos, int yPos, int brshSize, string msg) {
        Packet dataToSend ;
        // The 'with' statement allows us to access an object
        // (i.e. member variables and member functions)
        // in a slightly more convenient way
        with (dataToSend){
            user = "clientName\0";
            // Just some 'dummy' data for now
            // that the 'client' will continuously send
            x = xPos;
            y = yPos;
            r = mySurface.getColor().r;
            g = mySurface.getColor().g;
            b = mySurface.getColor().b;
            brushSize = brshSize;
            message = "test\0";
        }
        return dataToSend;
    }

    void refreshClientScreen() {
        auto serverReader = new Thread(() {
            char[Packet.sizeof] receiveBuffer;
            while (true) {
                // Read data from socket
                long bytesReceived = serverSocket.receive(receiveBuffer);
                if (bytesReceived > 0) {
                    auto fromServer = receiveBuffer[0 .. bytesReceived];

                    // Format the packet. Note, I am doing this in a very
                    // verbosoe manner so you can see each step.
                    Packet formattedPacket;
                    formattedPacket = Packet.getPacketFromBytes(receiveBuffer,Packet.sizeof);

                    if (formattedPacket.x < 0 || formattedPacket.x >= 800 || formattedPacket.y < 0 || formattedPacket.y >= 700) {
                        mySurface.ClearSurface();
                    } else {
                        int brshSize = formattedPacket.brushSize;
                        mySurface.setColor(new Color(formattedPacket.r, formattedPacket.g, formattedPacket.b));

                        Draw(formattedPacket.x, formattedPacket.y, brshSize, false, false);
                    }
                }
            }
        });

        // Start the server reader thread
        serverReader.start();
    }

    void undo() {
        writeln("undoStack.length: ",undoStack.length);
        if (undoStack.length > 0) {
            auto numUndos = 600;

            for (int i = 0; i < numUndos; i++) {
                if (undoStack.length > 0) {
                    Packet packetToUndo = undoStack[undoStack.length-1];
                    undoStack = undoStack[0..undoStack.length-1];

                    mySurface.setEraser();
                    Draw(packetToUndo.x, packetToUndo.y, packetToUndo.brushSize, true, true);
                    mySurface.setColor(new Color(packetToUndo.r, packetToUndo.g, packetToUndo.b));
                    redoStack ~= packetToUndo;
                }
            }
        }
    }

    void redo() {
        writeln("redoStack.length: ",redoStack.length);
        if (redoStack.length > 0) {
            auto numRedos = 600;

            for (int i = 0; i < numRedos; i++) {
                if (redoStack.length > 0) {
                    Packet packetToRedo = redoStack[redoStack.length-1];
                    redoStack = redoStack[0..redoStack.length-1];

                    mySurface.setColor(new Color(packetToRedo.r, packetToRedo.g, packetToRedo.b));
                    Draw(packetToRedo.x, packetToRedo.y, packetToRedo.brushSize, true, true);
                    undoStack ~= packetToRedo;
                }
            }
        }
    }

    void initSurface(){
        SDL_Surface* image;
        SDL_Rect* rect;
        // BlitSurface();
        image = SDL_LoadBMP("./../media/plus.bmp");
        rect = new SDL_Rect(0,0,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/brush.bmp");
        rect = new SDL_Rect(0,51,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/minus.bmp");
        rect = new SDL_Rect(0,102,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/black.bmp");
        rect = new SDL_Rect(0,201,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/white.bmp");
        rect = new SDL_Rect(0,252,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/blue.bmp");
        rect = new SDL_Rect(0,303,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/purple.bmp");
        rect = new SDL_Rect(0,354,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/green.bmp");
        rect = new SDL_Rect(0,405,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/orange.bmp");
        rect = new SDL_Rect(0,456,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/red.bmp");
        rect = new SDL_Rect(0,507,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/eraser.bmp");
        rect = new SDL_Rect(0,599,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);

        image = SDL_LoadBMP("./../media/clear-screen.bmp");
        rect = new SDL_Rect(0,650,50,50);
        SDL_BlitSurface(image, null, mySurface.imgSurface, rect);
        SDL_FreeSurface(image);
    }

    void BlitSurface() {
        // Blit the surace (i.e. update the window with another surfaces pixels
        //                       by copying those pixels onto the window).
        SDL_BlitSurface(mySurface.imgSurface,null,SDL_GetWindowSurface(window),null);
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