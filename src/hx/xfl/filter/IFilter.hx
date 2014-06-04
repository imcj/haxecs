package hx.xfl.filter;

interface IFilter
{
    function parse(data:Xml):Void;
    function clone():IFilter;
    function toString():String;
}