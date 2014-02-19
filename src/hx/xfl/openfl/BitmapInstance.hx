package hx.xfl.openfl;

import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMBitmapInstance;

import flash.display.Bitmap;
import flash.display.PixelSnapping;

class BitmapInstance extends Bitmap
{
    var dom:DOMBitmapInstance;

    public function new(dom:DOMBitmapInstance)
    {
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMBitmapItem = 
            cast(document.getMedia(dom.libraryItemName), DOMBitmapItem);

        var name = file.sourceExternalFilepath;
        if ("./" == name.substr(0, 2))
            name = name.substr(2);
        var bmd = openfl.Assets.getBitmapData(
            hx.Path.join(document.dir, [name]));

        super(bmd, PixelSnapping.AUTO, true);

        x = dom.matrix.tx;
        y = dom.matrix.ty;
    }
}