package hx.xfl.motion;

import hx.geom.Point;
import hx.xfl.assembler.XFLBaseAssembler;

class KeyFrame
{
    public var anchor:Point;
    public var next:Point;
    public var previous:Point;
    public var roving:Int;
    public var timevalue:Int;
    public var value:String;

    public function new()
    {
        anchor = new Point();
        next = new Point();
        previous = new Point();
    }
    
    public function getFrameIndex():Int
    {
        return Std.int(timevalue / 1000);
    }

    public function parse(data:Xml)
    {
        var assembler = new XFLBaseAssembler(null);
        assembler.fillProperty(this, data, ["anchor", "next", "previous"]);
        this.anchor = parsePoint(data.get("anchor"));
        this.next = parsePoint(data.get("next"));
        this.previous = parsePoint(data.get("previous"));
    }

    function parsePoint(str:String):Point
    {
        if (str == null) return new Point(0, 0);
        var arrStr = str.split(",");
        var px = Std.parseFloat(arrStr[0]);
        var py = Std.parseFloat(arrStr[1]);
        return new Point(px, py);
    }
}