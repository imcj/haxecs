package hx.xfl.openfl;

import flash.events.Event;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;

class Layer extends Sprite
{
    var dom:DOMLayer;

    public var currentFrame:Int;
    public var totalFrames:Int;

    public function new(dom:DOMLayer)
    {
        super();
        name = 'haxecs:layer:${dom.name}';

        this.dom = dom;
        this.totalFrames = dom.totalFrames;

        currentFrame = 0;
        play();
    }

    function onFrame(e:Event):Void 
    {
        if (currentFrame < totalFrames-1) 
        {
            currentFrame = currentFrame + 1;
            gotoFrame(currentFrame);
        }
    }

    public function play():Void 
    {
        gotoAndPlay(currentFrame);
    }

    public function stop():Void 
    {
        gotoAndStop(currentFrame);
    }

    public function gotoAndPlay(index:Int):Void 
    {
        currentFrame = index;
        gotoFrame(currentFrame);
        this.addEventListener(Event.ENTER_FRAME, onFrame);
    }

    public function gotoAndStop(index:Int):Void 
    {
        currentFrame = index;
        gotoFrame(currentFrame);
        this.removeEventListener(Event.ENTER_FRAME, onFrame);
    }

    function gotoFrame(index:Int):Void
    {
        if (index >= dom.totalFrames || index < 0)
            return;
        for (frame in dom.getFramesIterator()) {
            if (index >= frame.index &&
                index <  frame.index + frame.duration) {
                displayFrame(frame);
            }
        }
    }

    function displayFrame(frame:DOMFrame):Void
    {
        freeChildren();
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

    function freeChildren():Void
    {
        this.removeChildren();
    }
}