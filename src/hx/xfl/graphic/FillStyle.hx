package hx.xfl.graphic;
import hx.geom.Matrix;

class FillStyle
{
    public var index:Int;
    public var type:String;

    public var color:Int;
    public var alpha:Float;

    public var matrix:Matrix;
    public var gradientEntrys:Array<{color:Int,ratio:Float}>;

    public function new()
    {
        index = 1;
        type = "";
        color = 0;
        alpha = 1;
        gradientEntrys = [];
    }
    
}