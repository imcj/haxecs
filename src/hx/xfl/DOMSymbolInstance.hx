package hx.xfl;

import hx.geom.Matrix;

class DOMSymbolInstance extends DOMElement
{
    public var selected:Bool;
    public var symbolType:String;

    public function new()
    {
        super();

        selected = false;
        symbolType = "";
    }
}