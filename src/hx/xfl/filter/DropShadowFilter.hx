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
    
    public function new(distance:Float = 4, angle:Float = 45, color:UInt = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false)
    {
        super();
        this.color = color;
        this.alpha = alpha;
        this.blurX = blurX;
        this.blurY = blurY;
        this.angle = angle;
        this.distance = distance;
        this.hideObject = hideObject;
        this.inner = inner;
        this.knockout = knockout;
        this.quality = quality;
        this.strength = strength;
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