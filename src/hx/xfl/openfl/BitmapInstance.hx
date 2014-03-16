package hx.xfl.openfl;

import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMBitmapInstance;

import flash.display.Bitmap;
import flash.display.PixelSnapping;

class BitmapInstance extends Bitmap
{
    public var dom:DOMBitmapInstance;

    public function new(dom:DOMBitmapInstance)
    {
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMBitmapItem = cast(dom.libraryItem, DOMBitmapItem);

        var name = file.sourceExternalFilepath;
        if ("./" == name.substr(0, 2))
            name = name.substr(2);
        if ("+" == name.substr(0, 1))
            name = name.substr(1);
        var bmd = hx.xfl.openfl.Assets.getBitmapData(
            hx.Path.abspath(hx.Path.join(document.dir, [name])));

        super(bmd, PixelSnapping.AUTO, true);

        this.transform.matrix = dom.matrix.toFlashMatrix();
    }
}