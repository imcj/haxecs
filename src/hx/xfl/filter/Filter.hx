package hx.xfl.filter;

import flash.filters.BitmapFilter;
import hx.xfl.assembler.XFLBaseAssembler;
import hx.xfl.filter.IFilter;

class Filter implements IFilter
{
    var filter(get, null):BitmapFilter;
    
    public function new()
    {
    
    }

    function get_filter():BitmapFilter {
        throw("Implement in subclasses!");
        return null;
    }
    
    public function parse(data:Xml):Void {
        var assembler = new XFLBaseAssembler(null);
        assembler.fillProperty(this, data);
    }
    
    public function clone():IFilter {
        throw("Implement in subclasses!");
        return null;
    }

    public function toString():String
    {
        return "[Filter]";
    }
}