package hx.xfl.filter;

import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;

class BevelFilter extends Filter implements IFilter
{
    public var shadowColor:Int;
    public var shadowAlpha:Float;
    public var highlightColor:Int;
    public var highlightAlpha:Float;
    public var blurX:Float;
    public var blurY:Float;
    public var angle:Float;
    public var distance:Float;
    public var strength:Float;
    public var knockout:Bool;
    public var compositeSource:Bool;
    public var quality:Int;
    public var type:BitmapFilterType;
    
    public function new()
    {
    
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.BevelFilter(
            distance,
            angle * 180 / Math.PI,
            highlightColor,
            highlightAlpha,
            shadowColor,
            shadowAlpha,
            blurX,
            blurY,
            strength,
            quality+1,
            type,
            knockout
        );
    }
    
    override public function clone():IFilter
    {
        var filter:BevelFilter = new BevelFilter(id);
        filter.shadowColor = shadowColor;
        filter.shadowAlpha = shadowAlpha;
        filter.highlightColor = highlightColor;
        filter.highlightAlpha = highlightAlpha;
        filter.blurX = blurX;
        filter.blurY = blurY;
        filter.angle = angle;
        filter.distance = distance;
        filter.strength = strength;
        filter.quality = quality;
        filter.knockout = knockout;
        filter.type = type;
        return filter;
    }
    
    override public function toString():String
    {
        return "[BevelFilter]";
    }
}