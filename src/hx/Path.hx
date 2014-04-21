package hx;

using StringTools;

class Path
{
    static var path:IPath = new PosixPath();

    static public function __init__()
    {
        // #if flash
        // path = new PosixPath();
        // #else
        // #end
    }

    static public function join(a:String, b:Array<String>):String
    {
        return path.join(a, b);
    }

    static public function abspath(path:String):String
    {
        return Path.path.abspath(path);
    }

    static public function dirname(path:String):String
    {
        return Path.path.dirname(path);
    }
}