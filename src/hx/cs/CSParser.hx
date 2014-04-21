package hx.cs;

import as3hx.As3;
import as3hx.Config;
import as3hx.Parser;
import as3hx.Writer;

import haxe.io.BytesOutput;

class CSParser extends as3hx.Parser
{
    public function new(config)
    {
        super(config);
    }

    public function init(s:String)
    {
        line = 1;
        this.path = "";
        this.filename = "";

        char = 0;
        input = new haxe.io.StringInput(s);
        ops = new Array();
        idents = new Array();
        tokens = new haxe.ds.GenericStack<Token>();
        for( i in 0...identChars.length )
            idents[identChars.charCodeAt(i)] = true;
        for( op in opPriority.keys() )
            for( i in 0...op.length )
                if (!idents[op.charCodeAt(i)])
                    ops[op.charCodeAt(i)] = true;

    }

    static public function fromString(code:String):String
    {
        var config = new MockConfig();
        var parser = new CSParser(config);
        parser.init(code);

        var p = parser.parseString(code, "", "");
        var writer = new Writer(config); 
        var output = new BytesOutput();
        writer.process(p, output);

        return output.getBytes().toString();
    }

    static public function toAST(code:String):Program
    {
        var config = new MockConfig();
        var parser = new CSParser(config);
        parser.init(code);

        var p = parser.parseString(code, "", "");

        return p;   
    }

    static public function toString(?ast:Program):String
    {
        if (ast != null) {
            var config = new MockConfig();
            var writer = new Writer(config); 
            var output = new BytesOutput();
            writer.process(ast, output);

            return output.getBytes().toString();
        }

        return "";
    }

    static public function create(code:String)
    {
        var config = new MockConfig();
        var parser = new CSParser(config);
        parser.init(code);

        return parser;
    }
}