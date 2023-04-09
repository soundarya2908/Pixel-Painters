import core.stdc.string;
import std.json;

class ServerData {
    // Private member variables
    private string user;  // Perhaps a unique identifier
    private int x;
    private int y;
    private byte r;
    private byte g;
    private byte b;
    private int brushSize;
    private string message; // for debugging

    // Public member functions
    public:
    // Constructor
    this() {
        user = "test user\0";
        message = "test message\0";
    }

    // Getter and setter functions for private member variables
    string getUser() const {
        return user;
    }
    void setUser(string newUser) {
        user = newUser;
    }
    int getX() const {
        return x;
    }
    void setX(int newX) {
        x = newX;
    }
    int getBrushSize() const {
        return brushSize;
    }
    void setBrushSize(int brshSize) {
        brushSize = brshSize;
    }
    int getY() const {
        return y;
    }
    void setY(int newY) {
        y = newY;
    }
    byte getR() const {
        return r;
    }
    void setR(byte newR) {
        r = newR;
    }
    byte getG() const {
        return g;
    }
    void setG(byte newG) {
        g = newG;
    }
    byte getB() const {
        return b;
    }
    void setB(byte newB) {
        b = newB;
    }
    string getMessage() const {
        return message;
    }
    void setMessage(string newMessage) {
        message = newMessage;
    }

    /*string toJson()
    {
        //Json json;
        json["user"] = user;
        json["x"] = x;
        json["y"] = y;
        json["r"] = r;
        json["g"] = g;
        json["b"] = b;
        json["brushSize"] = brushSize;
        json["message"] = messgae;
        return json.toString();
    }*/
}
