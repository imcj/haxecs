package hx.xfl;

import hx.geom.Matrix;

class DOMElement implements IDOMElement
{
    public var frame:DOMFrame;
    public var libraryItemName(default, default):String;
    public var matrix(default, default):Matrix;
    public var centerPoint3DX(default, default):Float;
    public var centerPoint3DY(default, default):Float;
    public var width(default, default):Float;
    public var height(default, default):Float;

    public function new()
    {
        frame = null;
        libraryItemName = null;
        matrix = new Matrix();
        centerPoint3DX = -1;
        centerPoint3DY = -1;
        width = 0;
        height = 0;
    }
}