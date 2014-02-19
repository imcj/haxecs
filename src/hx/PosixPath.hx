package hx;

using StringTools;

class PosixPath implements IPath
{
    public function new()
    {

    }

    public function join(a:String, b:Array<String>):String
    {
        var path = a;
        for (p in b) {
            if (p.startsWith('/'))
                path = p;
            else if (path == '' || path.endsWith('/'))
                path += p;
            else
                path += '/' + p;
        }
        return path;
    }
}