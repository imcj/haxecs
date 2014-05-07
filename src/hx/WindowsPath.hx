package hx;

class WindowsPath implements IPath
{

    public function new()
    {
        
    }
    
    public function join(a:String, b:Dynamic):String
    {
        var path = a;
        var joinPath = [];
        if (Std.is(b, String)) joinPath = [b];
        if (Std.is(b, Array)) joinPath = b;
        if (joinPath.length == 0) return a;
        for (p in joinPath) {
            if (p.startsWith('/'))
                path = p;
            else if (path == '' || path.endsWith('/'))
                path += p;
            else
                path += '/' + p;
        }
        return path;
    }
    
    function isabs(s:String):Void 
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