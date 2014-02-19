package hx.xfl.openfl;

import hx.xfl.DOMLayer;
import hx.xfl.DOMBitmapInstance;
import flash.display.Sprite;

class Layer extends Sprite
{
    var dom:DOMLayer;

    public function new(dom:DOMLayer)
    {
        super();
        name = 'haxecs:layer:${dom.name}';

        this.dom = dom;

        for (frame in dom.getFramesIterator()) {
            for (element in frame.getElementsIterator()) {
                if (Std.is(element, DOMBitmapInstance)) {
                    var instance = cast(element, DOMBitmapInstance);
                    addChild(new BitmapInstance(instance));
                }
            }
        }
    }
}