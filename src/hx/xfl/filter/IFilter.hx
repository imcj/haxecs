package hx.xfl.filter;

import flash.filters.BitmapFilter;

interface IFilter
{
    var filter(get, null):BitmapFilter;
    function parse(data:Xml):Void;
    function clone():IFilter;
    function toString():String;
}