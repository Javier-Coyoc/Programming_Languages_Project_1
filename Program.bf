namespace Programming_Languages_Project_1;

using System;

class Program
{
    public static void Main()
    {
        while (true)
        {
            Console.WriteLine("==================================================");
            Console.WriteLine("BNF GRAMMAR:");
            Console.WriteLine("<program>      ::= begin <instructions> end");
            Console.WriteLine("<instructions> ::= <instruction> | <instruction> . <instructions>");
            Console.WriteLine("<instruction>  ::= SQR <coord>-<coord> | TRI <coord>-<coord>-<coord>");
            Console.WriteLine("<coord>        ::= <x><y>");
            Console.WriteLine("<x>            ::= A | B | C | D | E | F | G");
            Console.WriteLine("<y>            ::= 1 | 2 | 3 | 4 | 5 | 6");
            Console.WriteLine("==================================================");
            Console.Write("\nEnter input string (or EXIT to quit): ");

            String input = scope .();
            Console.ReadLine(input);
            input.Trim();

            if (input.Equals("EXIT", .OrdinalIgnoreCase))
                break;

            // 1. Run Rightmost Derivation
			// Execute Derivation and Parse Tree Generation
			ParseTreeNode treeRoot = null;
			if (Derivation.Process(input, out treeRoot))
			{
			    Console.WriteLine("--- PARSE TREE ---");
			    treeRoot.PrintTree("", true);
			    delete treeRoot;
			}
            // 2. If successful, construct and draw Parse Tree
            // 3. If unsuccessful, print specific error message
        }
    }
}