package hx.xfl;

import hx.geom.Matrix;

class DOMSymbolInstance extends DOMInstance
{
    public var selected:Bool;
    public var symbolType:String;
    public var loop:String;

    public function new()
    {
        super();

        selected = false;
        symbolType = "";
        loop = "";
    }
}