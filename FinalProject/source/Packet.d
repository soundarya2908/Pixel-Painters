// @file Packet.d
import core.stdc.string;

// NOTE: Consider the endianness of the target machine when you
//       send packets. If you are sending packets to different
//       operating systems with different hardware, the
//       bytes may be flipped!
//       A test you can do is to when you send a packet to a
//       operating system is send a 'known' value to the operating system
//       i.e. some number. If that number is expected (e.g. 12345678), then
//       the byte order need not be flipped.
struct Packet{
    // NOTE: Packets usually consist of a 'header'
    //   	 that otherwise tells us some information
    //  	 about the packet. Maybe the first byte
    // 	 	 indicates the format of the information.
    // 		 Maybe the next byte(s) indicate the length
    // 		 of the message. This way the server and
    // 		 client know how much information to work
    // 		 with.
    // For this example, I have a 'fixed-size' Packet
    // for simplicity -- effectively cramming every
    // piece of information I can think of.

    char[16] user;  // Perhaps a unique identifier
    int x;
    int y;
    byte r;
    byte g;
    byte b;
    int brushSize;
    char[64] message; // for debugging

    /// Purpose of this function is to pack a bunch of
    /// bytes into an array for 'serialization' or otherwise
    /// ability to send back and forth across a server, or for
    /// otherwise saving to disk.
    char[Packet.sizeof] GetPacketAsBytes(){
        char[Packet.sizeof] buffer = new char[Packet.sizeof];
        // Populate the buffer with the packet data
        memmove(&buffer, &user, user.sizeof);
        memmove(&buffer[16], &x, x.sizeof);
        memmove(&buffer[20], &y, y.sizeof);
        buffer[24] = r;
        buffer[25] = g;
        buffer[26] = b;
        memmove(&buffer[27], &brushSize, brushSize.sizeof);
        memmove(&buffer[31], &message, message.sizeof);
        return buffer;
    }

    static Packet getPacketFromBytes(char[Packet.sizeof] buffer, size_t bufferSize){
        Packet packet;
        // Check that the buffer is big enough to contain a Packet
        if (bufferSize < Packet.sizeof){
            return packet;
        }
        // Populate the packet fields with data from the buffer
        memmove(&packet.user, &buffer[0], packet.user.sizeof);
        memmove(&packet.x, &buffer[16], packet.x.sizeof);
        memmove(&packet.y, &buffer[20], packet.y.sizeof);
        packet.r = buffer[24];
        packet.g = buffer[25];
        packet.b = buffer[26];
        memmove(&packet.brushSize, &buffer[27], packet.brushSize.sizeof);
        memmove(&packet.message, &buffer[31], packet.message.sizeof);
        return packet;
    }



}