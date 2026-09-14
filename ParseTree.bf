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

    public void PrintTree(StringView indent = "", bool isLast = true)
    {
        Console.WriteLine($"{indent}{(isLast ? "└── " : "├── ")}{Name}");

        String newIndent = scope $"{indent}{(isLast ? "    " : "│   ")}";
        for (int i = 0; i < Children.Count; i++)
        {
            Children[i].PrintTree(newIndent, i == Children.Count - 1);
        }
    }
}
