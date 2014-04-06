package hx.geom;

class Point
{
    public var x:Float;
    public var y:Float;

    public function new(x=0.0, y=0.0)
    {
        this.x = x;
        this.y = y;
    }

    public function sub(point:{x:Float, y:Float}):Point 
    {
        return new Point(this.x - point.x, this.y - point.y);
    }
}