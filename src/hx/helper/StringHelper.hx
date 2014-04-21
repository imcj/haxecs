package hx.helper;

class StringHelper
{
    static public function repeat(a:String, len:Int):String
    {
        var returns:String = "";
        for (i in 0...len)
            returns += a;

        return returns;
    }

    static public function rstrip(a:String, b:String):String
    {
        var regular:EReg;
        if (!(null == b || "" == b))
            regular = new EReg(b + "$", "");
        else
            regular = new EReg("[\t\n \r]$", "");

        return regular.replace(a, "");
    }
}