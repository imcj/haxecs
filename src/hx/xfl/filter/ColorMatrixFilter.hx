package hx.xfl.filter;

import hx.xfl.filter.Filter;

class ColorMatrixFilter extends Filter
{
    var matrix:Array<Float>;

    public function new(matrix=null)
    {
        super();
        this.matrix = [];
        if (matrix != null) this.matrix = matrix;
    }
    
    override private function get_filter():BitmapFilter
    {
        return new flash.filters.ColorMatrixFilter(matrix);
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