package hx.xfl;
import hx.xfl.graphic.Edge;
import hx.xfl.graphic.FillStyle;
import hx.xfl.graphic.StrokeStyle;

class DOMShape extends DOMInstance
{
    public var isFloating:Bool; //还不清楚是做什么的

    public var fills:Map<Int,FillStyle>;
    public var strokes:Map<Int,StrokeStyle>;
    public var edges:Array<Edge>;
    public var fillEdges0:Array<Edge>;
    public var fillEdges1:Array<Edge>;

    public function new()
    {
        super();

        isFloating = false;
        fills = new Map();
        strokes = new Map();
        edges = [];
        fillEdges0 = [];
        fillEdges1 = [];
    }
    
}