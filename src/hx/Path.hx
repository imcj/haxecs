package hx;

using StringTools;

class Path
{
    static var path:IPath;

    static public function __init__()
    {
        var sys = Sys.systemName();
        
        if (~/Windows/.match(sys)) {
            path = new WindowsPath();
        }else {
            path = new PosixPath();
        }
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