package hx.xfl;

import hx.geom.Matrix;
import hx.geom.Point;

class DOMElement implements IDOMElement
{
    public var name:String;
    public var frame:DOMFrame;
    public var matrix(default, default):Matrix;
    public var transformPoint(default, default):Point;
    public var centerPoint3DX(default, default):Float;
    public var centerPoint3DY(default, default):Float;
    public var width(default, default):Float;
    public var height(default, default):Float;
    public var top(default, default):Float;
    public var left(default, default):Float;
    
    public var nowMatrix:Matrix;

    public function new()
    {
        frame = null;
        matrix = new Matrix();
        transformPoint = new Point();
        centerPoint3DX = -1;
        centerPoint3DY = -1;
        width = 0;
        height = 0;
        top = 0;
        left = 0;
        
        nowMatrix = new Matrix();
    }
}