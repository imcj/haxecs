package hx.xfl.openfl;

import flash.display.BitmapData;
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

    public function getBitmapDataWithBitmapItem(item:DOMBitmapItem)
    	:BitmapData
    {
        var name = item.href;
        if ("./" == name.substr(0, 2))
            name = name.substr(2);
        if ("+" == name.substr(0, 1))
            name = name.substr(1);
        var bmd = getBitmapData(
            hx.Path.abspath(hx.Path.join(document.dir, ["LIBRARY", name])));

        return bmd;
    }

    static public function getText(name:String):String
    {
    	return openfl.Assets.getText(name);
    }
}