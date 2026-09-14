using System;
using System.Collections;

namespace Programming_Languages_Project_1;

class ParseTreeNode
{
    public String Name = new .() ~ delete _;
    public List<ParseTreeNode> Children = new .() ~ DeleteContainerAndItems!(_);

    public this(StringView name)
    {
        Name.Set(name);
    }

    public void AddChild(ParseTreeNode child)
    {
        Children.Add(child);
    }

    public void PrintTree(String indent = "", bool isLast = true)
	{
	    Console.Write(indent);
	    if (isLast)
	        Console.Write("└── ");
	    else
	        Console.Write("├── ");

	    Console.WriteLine(Name);

	    String newIndent = scope .();
	    newIndent.Append(indent);
	    if (isLast)
	        newIndent.Append("    ");
	    else
	        newIndent.Append("│   ");

	    for (int i = 0; i < Children.Count; i++)
	    {
	        Children[i].PrintTree(newIndent, i == Children.Count - 1);
	    }
	}
}