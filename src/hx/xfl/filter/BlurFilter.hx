package hx.xfl.filter;

import flash.filters.BitmapFilter;

class BlurFilter extends Filter implements IFilter
{
    public var blurX:Float;
    public var blurY:Float;
    public var quality:Int;
    
    public function new()
    {
        
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.BlurFilter(
            blurX,
            blurY,
            quality
        );
    }
    
    override public function parse(data:Xml):Void
    {
        
    }
    
    override public function clone():IFilter
    {
        var filter:BlurFilter = new BlurFilter(id);
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