package hx.xfl.motion;
import flash.geom.Point;

class KeyFrame
{
    public var anchor:Point;
    public var next:Point;
    public var previous:Point;
    public var roving:Int;
    public var timevalue:Int;

    public function new()
    {
        anchor = new Point();
        next = new Point();
        previous = new Point();
    }
    
}