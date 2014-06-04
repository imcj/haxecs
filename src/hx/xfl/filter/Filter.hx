package hx.xfl.filter;

import hx.xfl.filter.IFilter;

class Filter implements IFilter
{
    public function new()
    {
    
    }

    public function parse():Void {
        throw(new Error("Implement in subclasses!"));
    }

    public function clone():IFilter {
        throw(new Error("Implement in subclasses!"));
        return null;
    }

    public function toString():String {
        return "[Filter]";
    }
}