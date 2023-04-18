import std.stdio;
import server;
import UserInput : UserInput;

void main() {
    auto userInput =new UserInput();
    string hostName = userInput.ValidatedHostNameInput();
    ushort port = userInput.ValidatedPortInput();
    auto server = new Server(hostName, port);
    server.RunServer();
}
