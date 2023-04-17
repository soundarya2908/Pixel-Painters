
/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;
import std.conv;

class UserInput {

    string ValidatedHostNameInput() {
        string hostName;
        bool validInput = false;

        while (!validInput)
        {
            writeln("Enter a Host Name/IP: ");
            hostName = readln().strip;

            validInput = true;

            // check if the input contains only letters or not
            foreach (char c; hostName)
            {
                if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')))
                {
                    writeln("Invalid input. Only strings are allowed.");
                    validInput = false;
                    break;
                }
            }
        }

        writeln("Input accepted: ", hostName);
        return hostName;
    }

    ushort ValidatedPortInput() {
        bool validInput = false;
        ushort input = 0;
        char ch;

        while (!validInput)
        {
            // Read in input as a string
            writeln("Enter a Port: ");
            string line = readln().chomp();
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

    bool ValidateUserInput() {
        bool validInput = false;
        int userInput;
        while (!validInput)
        {
            writeln("Enter 1 to run the Paint application in standalone mode: ");
            readf("%d", &userInput);
            if (userInput == 0 || userInput == 1)
            {
                validInput = true;
            }
            else
            {
                writeln("Invalid input. Please enter 0 or 1.");
            }
        }

        bool booleanInput = userInput == 1;
        writeln("You entered: ", booleanInput);
        return booleanInput;
    }
}