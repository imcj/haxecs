package hx;

using StringTools;

class WindowsPath implements IPath
{

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
        if (~/[a-z,A-Z]:/.match(s)) return true;
        else return false;
    }
    
    public function abspath(path:String):String
    {
        if (!isabs(path)) {
            path = join(Path.shellDir, [path]);
        }
        path = haxe.io.Path.normalize(path);
        return path;
    }
    
    public function dirname(path:String):String
    {
        return "";
    }
}