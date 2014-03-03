package hx;

interface IPath
{
    function join(a:String, b:Array<String>):String;
    function abspath(path:String):String;
}