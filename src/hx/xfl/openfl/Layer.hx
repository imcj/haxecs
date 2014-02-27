package hx.xfl.openfl;

import flash.events.Event;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;

import flash.errors.RangeError;

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
            } else if (Std.is(element, DOMSymbolInstance)) {
                var instance = cast(element, DOMSymbolInstance);
                addChild(new ButtonInstance(instance));
            } else if (Std.is(element, DOMText)) {
                var instance = cast(element, DOMText);
                addChild(new TextInstance(instance));
            }
        }
    }


    // TODO
    //
    // 下面的removeChildren是从openfl-native中拷贝过来的，在openfl-html5项目中api缺少
    // removeChidlren方法。
    // 把removeChildren方法移到openfl-html5项目中并pr。
    #if html5
    public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void {

        if (endIndex == 0x7fffffff) endIndex = __children.length;
        if (endIndex < beginIndex) throw new RangeError("removeChildren : endIndex must not be less than beginIndex");
        if (beginIndex < 0) throw new RangeError("removeChildren : beginIndex out of bounds " + beginIndex);
        if (endIndex > __children.length) throw new RangeError("removeChildren : endIndex out of bounds " + endIndex + "/" + __children.length);

        var numRemovals = endIndex - beginIndex;
        while (numRemovals >= 0) {
            removeChildAt(beginIndex);
            numRemovals --;
        }
    }   
    #end

    function freeChildren():Void
    {
        try {
            removeChildren();
        } catch (e:Dynamic) {
            // TODO
            // removeChildren
        }
    }
}