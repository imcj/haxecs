package hx.xfl;

import hx.geom.Matrix;

class DOMSymbolInstance extends DOMInstance
{
    public var selected:Bool;
    public var symbolType:String;
    public var loop:String;
    public var isVisible:Bool;
    public var silent:Bool;
    public var hasAccessibleData:Bool;  //尚不清楚功能
    public var forceSimple:Bool;

    public function new()
    {
        super();

        selected = false;
        symbolType = "";
        loop = "";
        silent = false;
        hasAccessibleData = false;
        forceSimple = false;
    }
}