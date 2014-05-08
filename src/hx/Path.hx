package hx;

using StringTools;

class Path
{
    static var path:IPath;

    static var _initialized:Bool = false;
    static public function initialize()
    {
        if (_initialized)
            return;
        #if (neko || cpp || php)
        var sys = Sys.systemName();
        
        if (~/Windows/.match(sys)) {
            path = new WindowsPath();
        }else {
            path = new PosixPath();
        }
        #else 
        path = new PosixPath();
        #end
    }

    static public function join(a:String, b:Array<String>):String
    {
        initialize();
        return path.join(a, b);
    }

    static public function abspath(path:String):String
    {
        initialize();
        return Path.path.abspath(path);
    }

    static public function dirname(path:String):String
    {
        initialize();
        return Path.path.dirname(path);
    }
}