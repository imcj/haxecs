package hx.xfl.openfl.display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import hx.xfl.DOMBitmapItem;

class BitmapInstance extends Bitmap implements IElement
{
    public var libraryItem:DOMBitmapItem;

    public function new(libraryItem:DOMBitmapItem, bitmapData:BitmapData,
        pixelSnapping, smoothing=false)
    {
        this.libraryItem = libraryItem;
        super(bitmapData, pixelSnapping, smoothing);
    }
}