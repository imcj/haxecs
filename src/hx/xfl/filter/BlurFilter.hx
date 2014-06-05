package hx.xfl.filter;

import flash.filters.BitmapFilter;

class BlurFilter extends Filter implements IFilter
{
    public var blurX:Float;
    public var blurY:Float;
    public var quality:Int;
    
    public function new(blurX:Float = 4, blurY:Float = 4, quality:Int = 1)
    {
        super();
        this.blurX = blurX;
        this.blurY = blurY;
        this.quality = quality;
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.BlurFilter(
            blurX,
            blurY,
            quality
        );
    }
    
    override public function clone():IFilter
    {
        var filter:BlurFilter = new BlurFilter();
        filter.blurX = blurX;
        filter.blurY = blurY;
        filter.quality = quality;
        return filter;
    }
    
    override public function toString():String
    {
        return "[BlurFilter]";
    }
}