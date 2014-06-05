package hx.xfl;

import flash.filters.BitmapFilter;
import hx.geom.ColorTransform;
import hx.geom.Matrix;
import hx.geom.Point;
import hx.xfl.filter.Filter;

class DOMElement implements IDOMElement
{
    public var name:String;
    public var frame:DOMFrame;
    public var matrix(default, default):Matrix;
    public var transformPoint(default, default):Point;
    public var centerPoint3DX(default, default):Float;
    public var centerPoint3DY(default, default):Float;
    public var width(default, default):Float;
    public var height(default, default):Float;
    public var top(default, default):Float;
    public var left(default, default):Float;
    public var colorTransform(default, default):ColorTransform;
    public var filters(default, default):Array<Filter>;
    
    public var flashFilters(get, null):Array<BitmapFilter>;

    public function new()
    {
        frame = null;
        matrix = new Matrix();
        transformPoint = new Point();
        colorTransform = new ColorTransform();
        centerPoint3DX = -1;
        centerPoint3DY = -1;
        width = 0;
        height = 0;
        top = 0;
        left = 0;
        filters = [];
    }
    
    function get_flashFilters():Array<BitmapFilter>
    {
        var fs = [];
        for (f in filters) {
            fs.push(f.filter);
        }
        return fs;
    }
}