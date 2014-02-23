package hx.xfl.openfl;

import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;

class Layer extends Sprite
{
    var dom:DOMLayer;

    public var totalFrames:Int;

    public function new(dom:DOMLayer)
    {
        super();
        name = 'haxecs:layer:${dom.name}';

        this.dom = dom;
        this.totalFrames = dom.totalFrames;
    }

    public function gotoFrame(index:Int):Void {
        if (index >= dom.totalFrames || index < 0)
            return;
        for (frame in dom.getFramesIterator()) {
            if (index >= frame.index &&
                index <  frame.index + frame.duration) {
                displayFrame(frame);
            }
        }
    }
    
    function displayFrame(frame:DOMFrame) {
        for (element in frame.getElementsIterator()) {
            if (Std.is(element, DOMBitmapInstance)) {
                var instance = cast(element, DOMBitmapInstance);
                addChild(new BitmapInstance(instance));
            }
            else if (Std.is(element, DOMSymbolInstance)) {
                var instance = cast(element, DOMSymbolInstance);
                addChild(new ButtonInstance(instance));
            }
        }
    }
}