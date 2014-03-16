package hx.xfl.openfl;

import flash.display.BitmapData;

using StringTools;

class Assets
{
    static public function getBitmapData(name:String):BitmapData
    {
        if (name.startsWith("/"))
            name = name.substr(1);

        return openfl.Assets.getBitmapData(name);
    }
}