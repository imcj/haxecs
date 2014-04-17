package hx.xfl.graphic;

#if openfl
import flash.display.BitmapData;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
#end
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
    #if openfl
    public var spreadMethod:SpreadMethod;
    public var interpolationMethod:InterpolationMethod;
    public var bitmapData:BitmapData;
    #end

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
        #if openfl
        spreadMethod = PAD;
        interpolationMethod = RGB;
        bitmapData = null;
        #end
    }
    
}