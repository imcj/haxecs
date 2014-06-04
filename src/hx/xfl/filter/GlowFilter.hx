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
    
    public function new()
    {
        
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
        var filter:GlowFilter = new GlowFilter(id);
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