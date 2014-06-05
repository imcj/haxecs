package hx.xfl.filter;

import flash.filters.BitmapFilter;

class DropShadowFilter extends Filter implements IFilter
{
    public var color:Int;
    public var alpha:Float;
    public var blurX:Float;
    public var blurY:Float;
    public var angle:Float;
    public var distance:Float;
    public var hideObject:Bool;
    public var inner:Bool;
    public var knockout:Bool;
    public var quality:Int;
    public var strength:Float;
    
    public function new()
    {
        super();
    }
    
    override function get_filter():BitmapFilter
    {
        return new flash.filters.DropShadowFilter(
            distance,
            angle * 180 / Math.PI,
            color,
            alpha,
            blurX,
            blurY,
            strength,
            quality,
            inner,
            knockout,
            hideObject
        );
    }
    
    override public function clone():IFilter
    {
        var filter:DropShadowFilter = new DropShadowFilter();
        filter.color = color;
        filter.blurX = blurX;
        filter.blurY = blurY;
        filter.angle = angle;
        filter.distance = distance;
        filter.alpha = alpha;
        filter.inner = inner;
        filter.hideObject = hideObject;
        filter.quality = quality;
        filter.knockout = knockout;
        filter.strength = strength;
        return filter;
    }
    
    override public function toString():String
    {
        return "[DropShadowFilter]";
    }
}