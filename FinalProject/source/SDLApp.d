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
        Packet[] packetHistory;
        Packet[] undoStack;
        Packet[] redoStack;

    public:
        this(string serverHost, ushort serverPort) {
            InitializeSDL();
            mySurface = new Surface();
            serverSocket = new Socket(AddressFamily.INET, SocketType.STREAM);
            serverSocket.connect(new InternetAddress(serverHost,serverPort));
            undoStack = new Packet[0];
            redoStack = new Packet[0];
            writeln("Connected to the Server");
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
        // Flag for determing if we are running the main application loop
        bool runApplication = true;
        // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
        //                                                but not yet released)
        bool drawing = false;

        refreshClientScreen();

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
                        Packet dataToSend = getPacketData(-1,-1, 3, "reset\0");
                        // Send the packet of information
                        serverSocket.send(dataToSend.GetPacketAsBytes());
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
                        draw(xPos, yPos, brshSize, true, false);
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
                        Packet dataToSend = getPacketData(-1,-1, 3, "reset\0");
                        // Send the packet of information
                        serverSocket.send(dataToSend.GetPacketAsBytes());
                        undoStack = new Packet[0];
                    } else if (e.key.keysym.sym == SDLK_u && SDL_GetModState() & KMOD_CTRL) {
                        writeln("undo operation");
                        undo();
                    } else if (e.key.keysym.sym == SDLK_r && SDL_GetModState() & KMOD_CTRL) {
                        writeln("redo operation");
                        //mySurface.redo();
                    }
                }
            }
            mySurface.BlitSurface();
        }
        mySurface.DestroyWindow();
    }

    void draw(int xPos, int yPos,int brshSize, bool sendData, bool undoing) {
        // Loop through and update specific pixels
        // NOTE: No bounds checking performed --
        //       think about how you might fix this :)
        for(int w=-brshSize; w < brshSize; w++){
            for(int h=-brshSize; h < brshSize; h++){
                mySurface.UpdateSurfacePixel(xPos+w,yPos+h);
                if(sendData) {
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

                        draw(formattedPacket.x, formattedPacket.y, brshSize, false, false);
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
            auto numUndos = 400;

            for (int i = 0; i < numUndos; i++) {
                if (undoStack.length > 0) {
                    Packet packetToUndo = undoStack[undoStack.length-1];
                    undoStack = undoStack[0..undoStack.length-1];

                    mySurface.setEraser();
                    draw(packetToUndo.x, packetToUndo.y, packetToUndo.brushSize, true, true);
                    mySurface.setColor(new Color(packetToUndo.r, packetToUndo.g, packetToUndo.b));
                }
            }
        }
    }
}