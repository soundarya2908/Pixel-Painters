module server;
// @file server.d
import std.socket;
import std.stdio;

import Packet : Packet;

class Server {
    private:
        Socket listener;
        SocketSet readSet;
        Socket[] connectedClientsList;
        string host;
        ushort port;
        Packet[] packetHistory;

    public:
        this(string host, ushort port) {
            listener = new Socket(AddressFamily.INET, SocketType.STREAM);
            // NOTE: It's possible the port number is in use if you are not able
            //  	 to connect. Try another one.
            listener.bind(new InternetAddress(host,port));
            // Allow 5 connections to be queued up
            listener.listen(5);
            readSet = new SocketSet();
        }

    void RunServer(){
        writeln("Starting server...");
        writeln("Server must be started before clients may join");

        // Message buffer will be large enough to send/receive Packet.sizeof
        char[Packet.sizeof] buffer;

        bool serverIsRunning=true;

        // Main application loop for the server
        writeln("Awaiting client connections");
        while(serverIsRunning){
            // Clear the readSet
            readSet.reset();
            // Add the server
            readSet.add(listener);
            foreach(client ; connectedClientsList){
                readSet.add(client);
            }


            // Handle each clients message
            if(Socket.select(readSet, null, null)){
                foreach(client; connectedClientsList){
                    // Check to ensure that the client
                    // is in the readSet before receving
                    // a message from the client.
                    if(readSet.isSet(client)){
                        // Server effectively is blocked
                        // until a message is received here.
                        // When the message is received, then
                        // we send that message from the
                        // server to the client
                        auto clientData = client.receive(buffer);

                        Packet receivedPacket;
                        receivedPacket = Packet.getPacketFromBytes(buffer, Packet.sizeof);
                        packetHistory ~= receivedPacket;

                        if (clientData !=0 && clientData!= Socket.ERROR) {
                            broadcastToOtherClients(connectedClientsList, client, buffer);
                        }
                    }
                }
                // The listener is ready to read
                // Client wants to connect so we accept here.
                addNewClients();
            }
        }
    }

    void addNewClients() {
        if(readSet.isSet(listener)){
            auto newSocket = listener.accept();
            // Based on how our client is setup,
            // we need to send them an 'acceptance'
            // message, so that the client can
            // proceed forward.
            newSocket.send("Welcome from server, you are now in our connectedClientsList");

            foreach(packet; packetHistory) {
                newSocket.send(packet.GetPacketAsBytes());
            }

            // Add a new client to the list
            connectedClientsList ~= newSocket;
            writeln("> client",connectedClientsList.length," added to connectedClientsList");
        }
    }

    void broadcastToOtherClients(Socket[] connectedClientsList, Socket sender, char[Packet.sizeof] buffer) {
        foreach(client; connectedClientsList) {
            if (client != sender) {
                client.send(buffer);
            }
        }
    }
}

