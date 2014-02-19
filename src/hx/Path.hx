package hx;

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
}