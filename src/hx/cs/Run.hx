package hx.cs;

import hx.xfl.*;

class Run
{
    static public function main()
    {
        var arguments:Array<String> = [];
        var options:Array<String> = [];
        for (argument in Sys.args())
            if (argument.startsWith("-"))
                options.push(argument);
            else
                arguments.push(argument);

        for (option in options) {

        }

        // 创建Sound对应的类文件。

        var xfl_path:String = "/Users/weicongju/Projects/haxecs/example/" +
            "piratepig/Assets/ASPiratePig";
        var as_path:String = "/Users/weicongju/Projects/" +
            "haxecs/example/piratepig/as3/";

        for (item in doc.getMediaIterator()) {
            if (Std.is(item, DOMSoundItem)) {
                var soundItem:DOMSoundItem = cast(item);
                soundItem.
            }
        }
    }
}