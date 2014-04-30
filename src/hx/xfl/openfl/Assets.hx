package hx.xfl.openfl;

#if openfl
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import hx.xfl.DOMItem;
import hx.xfl.DOMBitmapItem;
import hx.xfl.XFLDocument;

using StringTools;

class Assets
{
    public var document:XFLDocument;

    public function new(document:XFLDocument)
    {
        this.document = document;
    }

    public function getBitmapData(name:String):BitmapData
    {
        if (name.startsWith("/"))
            name = name.substr(1);

        return openfl.Assets.getBitmapData(name);
    }

    public function getBitmapByMediaName(name:String):Bitmap
    {
        return new Bitmap(
            getBitmapDataWithBitmapItem(cast(document.getMedia(name), DOMBitmapItem)),
            PixelSnapping.AUTO, true
        );
    }

    public function getBitmapDataByBitmapItem(name:DOMItem):BitmapData
    {
        return getBitmapDataWithBitmapItem(name);
    }

    public function getBitmapDataWithBitmapItem(item:DOMItem)
        :BitmapData
    {
        var name:String = cast(item, DOMBitmapItem).href;
        if ("./" == name.substr(0, 2))
            name = name.substr(2);
        if ("+" == name.substr(0, 1))
            name = name.substr(1);
        var bmd = getBitmapData(
            hx.Path.join(document.dir, ["LIBRARY", name]));

        return bmd;
    }

    static public function getText(name:String):String
    {
        return openfl.Assets.getText(name);
    }
}

#end