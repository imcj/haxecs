package hx.xfl.filter;

import flash.filters.BitmapFilter;

class GlowFilter extends Filter implements IFilter
{
    public var color:Int;
    public var alpha:Float;
    public var blurX:Float;
    public var blurY:Float;
    public var strength:Float;
    public var inner:Bool;
    public var knockout:Bool;
    public var quality:Int;
    
    public function new(color:Int = 16711680, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false)
    {
        super();
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.GlowFilter(
            color,
            alpha,
            blurX,
            blurY,
            strength,
            quality,
            inner,
            knockout
        );
    }
    
    override public function clone():IFilter
    {
        var filter:GlowFilter = new GlowFilter();
        filter.color = color;
        filter.alpha = alpha;
        filter.blurX = blurX;
        filter.blurY = blurY;
        filter.strength = strength;
        filter.quality = quality;
        filter.inner = inner;
        filter.knockout = knockout;
        return filter;
    }
    
    override public function toString():String
    {
        return "[GlowFilter]";
    }
}