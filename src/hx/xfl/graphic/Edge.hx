package hx.xfl.graphic;

class Edge
{
    public var fillStyle1:Int;
    public var strokeStyle:Int;
    public var edges:Array<EdgeCommand>;

    public function new()
    {
        fillStyle1 = 0;
        strokeStyle = 0;
        edges = [];
    }
    
}