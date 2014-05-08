package hx;

using StringTools;

class WindowsPath implements IPath
{
    public var shellDirector(get, null):String;

    public function new()
    {
        
    }
    
    public function join(a:String, b:Array<String>):String
    {
        var path = a;
        if (b.length == 0) return a;
        for (p in b) {
            if (p.startsWith('/'))
                path += p;
            else if (path == '' || path.endsWith('/'))
                path += p;
            else
                path += '/' + p;
        }
        return path;
    }
    
    function isabs(s:String):Bool 
    {
        return ~/[a-z,A-Z]:/.match(s);
    }
    
    public function abspath(path:String):String
    {
        if (!isabs(path)) {
            path = join(shellDirector, [path]);
        }
        path = haxe.io.Path.normalize(path);
        return path;
    }
    
    public function dirname(path:String):String
    {
        return "";
    }
    
    function get_shellDirector():String
    {
        var args = Sys.args();
        return args[args.length - 1];
    }
}