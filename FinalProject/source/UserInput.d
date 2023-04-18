// Import D standard libraries
import std.stdio;
import std.string;
import std.conv;


import std.regex : regex, match, matchAll;

/**
 * This class is used to validate user input.
 */
class UserInput {
    /**
     * This method is used to validate user input for the port name.
     */
    string ValidatedHostNameInput() {
        string hostName;
        bool validInput = false;

        writeln("Enter a Host Name/IP: ");
        hostName = readln().strip;
        if(hostName == "") {
            hostName = "localhost";
            writeln("No host entered, hence taking localhost as default hostName");
        }

        return hostName;
    }

    /**
     * This method is used to validate user input for a port number.
     */
    ushort ValidatedPortInput() {
        bool validInput = false;
        ushort input = 0;
        char ch;

        while (!validInput)
        {
            // Read in input as a string
            writeln("Enter a Port: ");
            string line = readln().chomp();
            if(line == "") {
                input = 50002;
                writeln("No port entered, hence taking default port(50002)");
                break;
            }
            // Validate that the input is only made up of digits
            bool allDigits = true;
            foreach (i, char c; line)
            {
                if (c < '0' || c > '9')
                {
                    allDigits = false;
                    break;
                }
            }
            // If all input characters are digits, convert to ushort and exit loop
            if (allDigits)
            {
                input = 0;
                foreach (i, char c; line)
                {
                    input *= 10;
                    input += c - '0';
                }
                validInput = true;
            }
            else
            {
                writeln("Invalid input. Please enter a positive whole number.");
            }
        }

        return input;
    }

    /**
     * This method is used to validate user input for whether a standalone mode is needed or not.
     */
    bool ValidateUserInput() {
        string userInput;
        writeln("By Default the app runs on network. Enter 1 to run in standalone mode");
        userInput = readln().strip;

        if(userInput == "1") {
            return true;
        }

        return false;
    }
}
