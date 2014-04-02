package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.Matrix;
import hx.xfl.DOMAnimationCore;

class MotionObject
{
    public var dom:DOMAnimationCore;

    public function new(dom)
    {
        this.dom = dom;
    }

    public function getMatrix(frame:Int):Matrix 
    {
        var matrix = new Matrix();
        return matrix;
    }
}