package hx;

using StringTools;
using hx.helper.StringHelper;

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

    function isabs(s:String):Bool
    {
        return s.startsWith("/");
    }

    function repeat(s:String, num:Int)
    {
        var r:String = "";
        for (i in 0...num)
            r += s;

        return r;
    }

    function normpath(path:String):String
    {
        if ('' == path)
            return '.';

        var dot = '.';
        var slash = '/';
        var initial_slashes:Int = -1;
        if (slash == path.substr(0, 1))
            initial_slashes = 1;

        if (initial_slashes > -1
            && path.startsWith("//")
            && ! path.startsWith("///"))
            initial_slashes = 2;

        var comps = path.split("/");
        var new_comps:Array<String> = [];

        for (comp in comps) {
            if (comp == '' || comp == ".")
                continue;
            if (comp != '..'
                || (-1 == initial_slashes && 0 == new_comps.length)
                || (0 < new_comps.length
                    && new_comps[new_comps.length - 1] == '..'))
                new_comps.push(comp)
            else if (0 < new_comps.length)
                new_comps.pop();
        }
        path = new_comps.join(slash);
        if (0 < initial_slashes)
            path = repeat(slash, initial_slashes) + path;

        return if (path == "") dot else path;
    }

    public function abspath(path:String):String
    {
        #if (cpp||neko||php)
        if (!isabs(path))
            path = join(Sys.getCwd(), [path]);
        #end
        return normpath(path);
    }

    public function dirname(path:String):String
    {
        var i = path.lastIndexOf("/") + 1;
        var head = path.substring(0, i);

        var slash = "";
        for (i in 0...head.length)
            slash += "/";
        if (!(null == head && "" == head && head == head.repeat(head.length)))
            head = head.rstrip("/");
        return head;
    }
}