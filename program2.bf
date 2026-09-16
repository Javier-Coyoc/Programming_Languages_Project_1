namespace Prog_lang_project_1;

using System;
using System.Collections;

class Program
{
    public static int Main(String[] args)
    {
		{
			String input = scope String(1024);

			while (true)
			{
				// Display required BNF Grammar
				Console.WriteLine("==================================================");
				Console.WriteLine("BNF GRAMMAR:");
				Console.WriteLine("<program>      ::= begin <instructions> end");
				Console.WriteLine("<instructions> ::= <instruction> | <instruction> . <instructions>");
				Console.WriteLine("<instruction>  ::= SQR <coord>-<coord> | TRI <coord>-<coord>-<coord>");
				Console.WriteLine("<coord>        ::= <x><y>");
				Console.WriteLine("<x>            ::= A | B | C | D | E | F | G");
				Console.WriteLine("<y>            ::= 1 | 2 | 3 | 4 | 5 | 6");
				Console.WriteLine("==================================================");
				Console.Write("\nEnter string (or EXIT to quit): ");

				input.Clear();
				Console.ReadLine(input);
				input.Trim();

				if (input.Equals("EXIT", .OrdinalIgnoreCase))
					break;

				Console.WriteLine();

				// Check grammar validation
				if (CheckProgram(input))
				{
					Console.WriteLine("\nAccepted.\n");

					// 1. Rightmost Derivation
					Console.WriteLine("--- RIGHTMOST DERIVATION ---");
					ShowDerivation(input);

					// 2. Parse Tree Drawing
					Console.WriteLine("--- PARSE TREE ---");
					ShowParseTree(input);
				}

				Console.WriteLine("\nPress Enter to continue...");
				String pauseInput = scope String(10);
				Console.ReadLine(pauseInput);
				Console.WriteLine();
			}

			return 0;
		}

		/*       CHECK PROGRAM       */
		static bool CheckProgram(StringView input)
		{
			if (!input.StartsWith("begin "))
			{
				Console.WriteLine("Error: Program must begin with 'begin'.");
				return false;
			}

			if (!input.EndsWith(" end"))
			{
				Console.WriteLine("Error: Program must end with 'end'.");
				return false;
			}

			int position = 6;
			int end = input.Length - 4;

			if (!CheckInstruction(input, ref position, end))
				return false;

			while (position < end)
			{
				if (input[position] != '.')
				{
					Console.WriteLine("Error: Expected '.' between instructions.");
					return false;
				}

				position++;

				if (position < end && input[position] == ' ')
					position++;

				if (!CheckInstruction(input, ref position, end))
					return false;
			}

			return true;
		}

		/*       CHECK INSTRUCTION       */
		static bool CheckInstruction(StringView input, ref int position, int end)
		{
			// SQR Check
			if (position + 4 <= end &&
				input[position] == 'S' &&
				input[position + 1] == 'Q' &&
				input[position + 2] == 'R' &&
				input[position + 3] == ' ')
			{
				position += 4;

				if (!CheckCoordinate(input, ref position, end))
					return false;

				if (position >= end || input[position] != '-')
				{
					Console.WriteLine("Error: Expected '-' in SQR.");
					return false;
				}

				position++;

				if (!CheckCoordinate(input, ref position, end))
					return false;

				return true;
			}

			// TRI Check
			if (position + 4 <= end &&
				input[position] == 'T' &&
				input[position + 1] == 'R' &&
				input[position + 2] == 'I' &&
				input[position + 3] == ' ')
			{
				position += 4;

				if (!CheckCoordinate(input, ref position, end))
					return false;

				if (position >= end || input[position] != '-')
				{
					Console.WriteLine("Error: Expected '-' in TRI.");
					return false;
				}

				position++;

				if (!CheckCoordinate(input, ref position, end))
					return false;

				if (position >= end || input[position] != '-')
				{
					Console.WriteLine("Error: Expected '-' in TRI.");
					return false;
				}

				position++;

				if (!CheckCoordinate(input, ref position, end))
					return false;

				return true;
			}

			Console.WriteLine("Error: Shape not valid.");
			return false;
		}

		/*       CHECK COORDINATE       */
		static bool CheckCoordinate(StringView input, ref int position, int end)
		{
			if (position >= end)
			{
				Console.WriteLine("Error: Coordinate expected.");
				return false;
			}

			char8 x = input[position];
			if (x < 'A' || x > 'G')
			{
				if (position + 1 < end)
				{
					char8 y = input[position + 1];
					Console.WriteLine($"Error: {x}{y} contains an error - variable '{x}' is not valid");
				}
				else
				{
					Console.WriteLine($"Error: Variable '{x}' is not valid.");
				}

				return false;
			}

			position++;

			if (position >= end)
			{
				Console.WriteLine("Error: Coordinate is incomplete.");
				return false;
			}

			char8 y = input[position];
			if (y < '1' || y > '6')
			{
				Console.WriteLine($"Error: {x}{y} contains the unrecognized value {y}");
				return false;
			}

			position++;
			return true;
		}

		/*       RIGHTMOST DERIVATION       */
		static void ShowDerivation(StringView input)
		{
			Console.WriteLine("<program>");
			Console.WriteLine("-> begin <instructions> end");

			int start = 6;
			int end = input.Length - 4;
			int instructionCount = 1;

			for (int i = start; i < end; i++)
			{
				if (input[i] == '.')
					instructionCount++;
			}

			if (instructionCount == 1)
			{
				Console.WriteLine("-> begin <instruction> end");
			}
			else
			{
				Console.WriteLine("-> begin <instruction> . <instructions> end");
			}

			Console.WriteLine($"-> {input}\n");
			Console.WriteLine("Final generated sentence:");
			Console.WriteLine(input);
		}

		/*       PARSE TREE DRAWING       */
		static void ShowParseTree(StringView input)
		{
			StringView body = input.Substring(6, input.Length - 10);

			Console.WriteLine("<program>");
			Console.WriteLine("├── begin");
			Console.WriteLine("├── <instructions>");

			for (var part in body.Split('.'))
			{
				StringView inst = part;
				inst.Trim();
				if (inst.IsEmpty) continue;

				Console.WriteLine("│   ├── <instruction>");

				// Split shape command from coordinates
				int spaceIdx = inst.IndexOf(' ');
				if (spaceIdx == -1) continue;

				StringView shape = inst.Substring(0, spaceIdx);
				StringView coords = inst.Substring(spaceIdx + 1);

				Console.WriteLine($"│   │   ├── {shape}");

				for (var c in coords.Split('-'))
				{
					StringView coord = c;
					coord.Trim();
					if (coord.Length == 2)
					{
						Console.WriteLine("│   │   ├── <coord>");
						Console.WriteLine($"│   │   │   ├── <x> ({coord[0]})");
						Console.WriteLine($"│   │   │   └── <y> ({coord[1]})");
					}
				}
			}

			Console.WriteLine("└── end");
		}
	}
} 