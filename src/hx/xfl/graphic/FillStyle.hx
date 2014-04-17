package hx.xfl.graphic;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import hx.geom.Matrix;

class FillStyle
{
    public var index:Int;
    public var type:String;

    public var color:Int;
    public var alpha:Float;

    public var matrix:Matrix;
    public var colors:Array<Int>;
    public var alphas:Array<Float>;
    public var ratios:Array<Float>;
    public var focalPointRatio:Float;
    public var spreadMethod:SpreadMethod;
    public var interpolationMethod:InterpolationMethod;

    public function new()
    {
        index = 1;
        type = "";
        color = 0;
        alpha = 1;
        matrix = new Matrix();
        colors = [];
        ratios = [];
        alphas = [];
        focalPointRatio = 0;
        spreadMethod = PAD;
        interpolationMethod = RGB;
    }
    
}