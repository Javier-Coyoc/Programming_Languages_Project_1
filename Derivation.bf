using System;
using System.Collections;

namespace Programming_Languages_Project_1;

class Derivation
{
    public static bool Process(StringView input, out ParseTreeNode rootNode)
    {
        rootNode = null;

        if (!input.StartsWith("begin ") || !input.EndsWith(" end"))
        {
            Console.WriteLine("Error: Program must start with 'begin' and end with 'end'.");
            return false;
        }

        StringView body = input.Substring(6, input.Length - 10);
        body.Trim();

        if (body.IsEmpty)
        {
            Console.WriteLine("Error: Missing instructions inside 'begin ... end'.");
            return false;
        }

        List<StringView> rawInstructions = scope .();
        for (var part in body.Split('.'))
        {
            StringView p = part;
            p.Trim();
            if (!p.IsEmpty)
                rawInstructions.Add(p);
        }

        for (int i = 0; i < rawInstructions.Count; i++)
        {
            if (!ValidateInstruction(rawInstructions[i]))
                return false;
        }

        Console.WriteLine("\n--- RIGHTMOST DERIVATION ---");
        PrintRightmostDerivation(rawInstructions);

        rootNode = BuildTree(rawInstructions);
        return true;
    }

    private static bool ValidateInstruction(StringView inst)
    {
        List<StringView> tokens = scope .();
        for (var token in inst.Split(' '))
        {
            StringView t = token;
            t.Trim();
            if (!t.IsEmpty)
                tokens.Add(t);
        }

        if (tokens.Count != 2)
        {
            Console.WriteLine($"Error: Invalid instruction format '{inst}'");
            return false;
        }

        StringView type = tokens[0];
        StringView coords = tokens[1];

        int expectedCoords = 0;
        if (type == "SQR") expectedCoords = 2;
        else if (type == "TRI") expectedCoords = 3;
        else
        {
            Console.WriteLine($"Error: Unrecognized command '{type}'");
            return false;
        }

        List<StringView> coordList = scope .();
        for (var c in coords.Split('-'))
        {
            StringView coordStr = c;
            coordStr.Trim();
            if (!coordStr.IsEmpty)
                coordList.Add(coordStr);
        }

        if (coordList.Count != expectedCoords)
        {
            Console.WriteLine($"Error: {type} expects {expectedCoords} coordinates separated by '-', found {coordList.Count}.");
            return false;
        }

        for (var coord in coordList)
        {
            if (coord.Length != 2)
            {
                Console.WriteLine($"Error: Invalid coordinate format '{coord}'. Must be <x><y>.");
                return false;
            }

            char8 x = coord[0];
            char8 y = coord[1];

            if (x < 'A' || x > 'G')
            {
                Console.WriteLine($"Error: {coord} contains the unrecognized column variable '{x}'. Must be A-G.");
                return false;
            }

            if (y < '1' || y > '6')
            {
                Console.WriteLine($"Error: {coord} contains the unrecognized value {y}");
                return false;
            }
        }

        return true;
    }

    private static void PrintRightmostDerivation(List<StringView> instructions)
    {
        int step = 1;
        Console.WriteLine($"{step++:D2}  <program>               => begin <instructions> end");

        // Step 1: Expand <instructions> rightward
        if (instructions.Count == 1)
        {
            Console.WriteLine($"{step++:D2}                          => begin <instruction> end");
            DeriveSingleInstruction(ref step, instructions[0]);
        }
        else
        {
            // Structural rightmost derivation expansion for multiple instructions
            Console.WriteLine($"{step++:D2}                          => begin <instruction> . <instructions> end");
            
            // Expand remaining instructions sequence
            for (int i = 1; i < instructions.Count; i++)
            {
                Console.WriteLine($"{step++:D2}                          => begin ... . {instructions[i]} end");
            }

            for (int i = 0; i < instructions.Count; i++)
            {
                DeriveSingleInstruction(ref step, instructions[i]);
            }
        }
    }

    private static void DeriveSingleInstruction(ref int step, StringView inst)
    {
        List<StringView> parts = scope .();
        for (var p in inst.Split(' '))
        {
            StringView partStr = p;
            partStr.Trim();
            if (!partStr.IsEmpty) parts.Add(partStr);
        }

        StringView type = parts[0];
        List<StringView> coords = scope .();
        for (var c in parts[1].Split('-'))
        {
            StringView cStr = c;
            cStr.Trim();
            coords.Add(cStr);
        }

        if (type == "SQR")
        {
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <coord>-<coord> ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <coord>-<x><y> ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <coord>-<x>{coords[1][1]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <coord>-{coords[1]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <x><y>-{coords[1]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR <x>{coords[0][1]}-{coords[1]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... SQR {coords[0]}-{coords[1]} ... end");
        }
        else if (type == "TRI")
        {
            Console.WriteLine($"{step++:D2}                          => begin ... TRI <coord>-<coord>-<coord> ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... TRI <coord>-<coord>-{coords[2]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... TRI <coord>-{coords[1]}-{coords[2]} ... end");
            Console.WriteLine($"{step++:D2}                          => begin ... TRI {coords[0]}-{coords[1]}-{coords[2]} ... end");
        }
    }

    private static ParseTreeNode BuildTree(List<StringView> instructions)
    {
        ParseTreeNode root = new ParseTreeNode("<program>");
        root.AddChild(new ParseTreeNode("begin"));

        ParseTreeNode instructionsNode = new ParseTreeNode("<instructions>");

        for (var instStr in instructions)
        {
            ParseTreeNode instNode = new ParseTreeNode("<instruction>");
            
            List<StringView> parts = scope .();
            for (var p in instStr.Split(' '))
            {
                StringView partStr = p;
                partStr.Trim();
                if (!partStr.IsEmpty) parts.Add(partStr);
            }

            instNode.AddChild(new ParseTreeNode(parts[0])); // SQR or TRI

            List<StringView> coords = scope .();
            for (var c in parts[1].Split('-'))
            {
                StringView cStr = c;
                cStr.Trim();
                coords.Add(cStr);
            }

            for (int i = 0; i < coords.Count; i++)
            {
                if (i > 0) instNode.AddChild(new ParseTreeNode("-"));

                ParseTreeNode coordNode = new ParseTreeNode("<coord>");
                
                ParseTreeNode xNode = new ParseTreeNode("<x>");
                xNode.AddChild(new ParseTreeNode(scope $"{coords[i][0]}"));
                
                ParseTreeNode yNode = new ParseTreeNode("<y>");
                yNode.AddChild(new ParseTreeNode(scope $"{coords[i][1]}"));

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