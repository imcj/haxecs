package hx.xfl.filter;

import flash.filters.BitmapFilter;
import hx.xfl.filter.Filter;

class ColorMatrixFilter extends Filter
{
    var matrix:Array<Float>;
    public var brightness(default, set):Float;
    public var contrast(default, set):Float;
    public var saturation(default, set):Float;
    public var hue(default, set):Float;

    public function new(matrix=null)
    {
        super();
        this.matrix = [1, 0, 0, 0, 0,
                       0, 1, 0, 0, 0,
                       0, 0, 1, 0, 0,
                       0, 0, 0, 1, 0];
        if (matrix != null) this.matrix = matrix;
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.ColorMatrixFilter(matrix);
    }
    
    function set_brightness(v:Float):Float
    {
        matrix[4] = v;
        matrix[9] = v;
        matrix[14] = v;
        return v;
    }
    
    function set_contrast(v:Float):Float
    {
        matrix[0] = v/100 * 11;
        matrix[6] = v/100 * 11;
        matrix[12] = v/100 * 11;
        matrix[4] = v/100 * -635;
        matrix[9] = v/100 * -635;
        matrix[14] = v/100 * -635;
        return v;
    }
    
    function set_saturation(v:Float):Float
    {
        
        return v;
    }
    
    function set_hue(v:Float):Float
    {
        
        return v;
    }
    
    override public function parse(data:Xml):Void {
        super.parse(data);
        var bright = data.get("brightness");
        if (bright != null) brightness = Std.parseFloat(bright);
        var c = data.get("contrast");
        if (c != null) contrast = Std.parseFloat(c);
    }
    
    override public function clone():IFilter
    {
        var filter:ColorMatrixFilter = new ColorMatrixFilter();
        filter.matrix = matrix;
        return filter;
    }
    
    override public function toString():String
    {
        return "[ColorMatrixFilter]";
    }
}