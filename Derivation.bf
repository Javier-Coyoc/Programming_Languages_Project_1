using System;
using System.Collections;

namespace Programming_Languages_Project_1;

class Derivation
{
    public static bool Process(StringView input, out ParseTreeNode rootNode)
    {
        rootNode = null;

        // 1. Check to see if input string has begin and end 
        if (!input.StartsWith("begin") || !input.EndsWith("end"))
        {
            Console.WriteLine("Error: Must start with 'begin' and end with 'end'.");
            return false;
        }

        // 2. Extract the instructions from inside of begin and end
        StringView body = input.Substring(5, input.Length - 8);
        body.Trim();

        if (body.IsEmpty)
        {
            Console.WriteLine("Error: Missing instructions inside 'begin ... end'.");
            return false;
        }

        // 3. Separate multiple instructions by '.'
        List<StringView> instructions = scope .();
        for (var part in body.Split('.'))
        {
            StringView cleaned = part;
            cleaned.Trim();
            if (!cleaned.IsEmpty)
            {
                instructions.Add(cleaned);
            }
        }

        // 4. Validate every instruction
        for (int i = 0; i < instructions.Count; i++)
        {
            if (!ValidateInstruction(instructions[i]))
            {
                return false;
            }
        }

        // 5. Print the step-by-step derivation
        Console.WriteLine("\n--- RIGHTMOST DERIVATION ---");
        PrintDerivation(instructions);

        // 6. Build and return the tree
        rootNode = BuildTree(instructions);
        return true;
    }

    private static bool ValidateInstruction(StringView inst)
    {
        // Split instruction into action (SQR/TRI) and coordinates
        List<StringView> parts = scope .();
        for (var token in inst.Split(' '))
        {
            StringView cleaned = token;
            cleaned.Trim();
            if (!cleaned.IsEmpty)
            {
                parts.Add(cleaned);
            }
        }

        if (parts.Count != 2)
        {
            Console.WriteLine($"Error: Invalid instruction format '{inst}'");
            return false;
        }

        StringView command = parts[0];
        StringView coordsString = parts[1];

        // Check required coordinate count
        int expectedCoords = 0;
        if (command == "SQR")
        {
            expectedCoords = 2;
        }
        else if (command == "TRI")
        {
            expectedCoords = 3;
        }
        else
        {
            Console.WriteLine($"Error: Unrecognized command '{command}'");
            return false;
        }

        // Separate coordinates by '-'
        List<StringView> coordList = scope .();
        for (var c in coordsString.Split('-'))
        {
            StringView cleaned = c;
            cleaned.Trim();
            if (!cleaned.IsEmpty)
            {
                coordList.Add(cleaned);
            }
        }

        if (coordList.Count != expectedCoords)
        {
            Console.WriteLine($"Error: {command} expects {expectedCoords} coordinates, found {coordList.Count}.");
            return false;
        }

        // Check each coordinate
        for (int i = 0; i < coordList.Count; i++)
        {
            StringView coord = coordList[i];

            if (coord.Length != 2)
            {
                Console.WriteLine($"Error: Invalid coordinate '{coord}'. Must be 2 characters (e.g. A1).");
                return false;
            }

            char8 x = coord[0];
            char8 y = coord[1];

            // Validate X (Column: A to G)
            if (x < 'A' || x > 'G')
            {
                Console.WriteLine($"Error: {coord} contains unrecognized column variable '{x}'. Must be A-G.");
                return false;
            }

            // Validate Y (Row: 1 to 6)
            if (y < '1' || y > '6')
            {
                Console.WriteLine($"Error: {coord} contains the unrecognized value {y}");
                return false;
            }
        }

        return true;
    }

    private static void PrintDerivation(List<StringView> instructions)
    {
        Console.WriteLine("01  <program>               => begin <instructions> end");
        Console.WriteLine("02                          => begin <instruction> end");

        for (int i = 0; i < instructions.Count; i++)
        {
            StringView inst = instructions[i];

            if (inst.StartsWith("SQR"))
            {
                Console.WriteLine("03                          => begin ... SQR <coord>-<coord> ... end");
            }
            else
            {
                Console.WriteLine("03                          => begin ... TRI <coord>-<coord>-<coord> ... end");
            }

            Console.WriteLine($"04                          => begin ... {inst} ... end");
        }

        // Reconstruct full output sentence
        String fullSentence = scope .("begin ");
        for (int i = 0; i < instructions.Count; i++)
        {
            if (i > 0) {
            	fullSentence.Append(" . ");
            }
            fullSentence.Append(instructions[i]);
        }
        fullSentence.Append(" end");

        Console.WriteLine($"=> Final Sentence: {fullSentence}\n");
    }

    private static ParseTreeNode BuildTree(List<StringView> instructions)
    {
        ParseTreeNode root = new ParseTreeNode("<program>");
        root.AddChild(new ParseTreeNode("begin"));

        ParseTreeNode instructionsNode = new ParseTreeNode("<instructions>");

        for (int i = 0; i < instructions.Count; i++)
        {
            ParseTreeNode instNode = new ParseTreeNode("<instruction>");

            List<StringView> parts = scope .();
            for (var p in instructions[i].Split(' '))
            {
                StringView cleaned = p;
                cleaned.Trim();
                if (!cleaned.IsEmpty)
                {
                    parts.Add(cleaned);
                }
            }

            // Add Command (SQR or TRI)
            instNode.AddChild(new ParseTreeNode(parts[0]));

            // Add Coordinates
            List<StringView> coords = scope .();
            for (var c in parts[1].Split('-'))
            {
                StringView cleaned = c;
                cleaned.Trim();
                coords.Add(cleaned);
            }

            for (int j = 0; j < coords.Count; j++)
            {
                if (j > 0)
                {
                    instNode.AddChild(new ParseTreeNode("-"));
                }

                ParseTreeNode coordNode = new ParseTreeNode("<coord>");

                ParseTreeNode xNode = new ParseTreeNode("<x>");
                xNode.AddChild(new ParseTreeNode(scope $"{coords[j][0]}"));

                ParseTreeNode yNode = new ParseTreeNode("<y>");
                yNode.AddChild(new ParseTreeNode(scope $"{coords[j][1]}"));

                coordNode.AddChild(xNode);
                coordNode.AddChild(yNode);

                instNode.AddChild(coordNode);
            }

            instructionsNode.AddChild(instNode);
        }

        root.AddChild(instructionsNode);
        root.AddChild(new ParseTreeNode("end"));

        return root;
    }
}
