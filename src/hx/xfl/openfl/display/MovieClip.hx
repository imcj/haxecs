package hx.xfl.openfl.display;

import flash.events.Event;
import hx.geom.Matrix;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;

import flash.errors.RangeError;

class MovieClip extends Sprite
{
    var domTimeLine:DOMTimeLine;

    public var currentFrame:Int;
    public var totalFrames:Int;

    public function new(domTimeLine:DOMTimeLine)
    {
        super();
        name = '';
        this.domTimeLine = domTimeLine;
        this.totalFrames = 0;
        for (layer in domTimeLine.layers) {
            if (this.totalFrames < layer.totalFrames) {
                this.totalFrames = layer.totalFrames;
            }
        }

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
        if (index < 0)
            return;

        // TODO
        displayFrame();
    }

    function displayFrame():Void
    {
        freeChildren();

        var frame;
        for (layer in domTimeLine.getLayersIterator(false)) {
            frame = layer.getFrameAt(currentFrame);
            if (frame == null) continue;
            for (element in frame.getElementsIterator()) {
                if (Std.is(element, DOMBitmapInstance)) {
                    var instance = cast(element, DOMBitmapInstance);
                    var displayObject = new BitmapInstance(instance);
                    
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    addChild(displayObject);
                } else if (Std.is(element, DOMSymbolInstance)) {
                    var instance = cast(element, DOMSymbolInstance);

                    // 动画
                    var matrix = instance.matrix;
                    if (frame.tweenType == "motion") {
                        var nextFrame = frame;
                        for (n in 0...layer.frames.length) {
                            if (layer.frames[n] == frame) {
                                nextFrame = layer.frames[n + 1];
                            }
                        }
                        var starMatrix = frame.elements[0].matrix;
                        var endMatrix = nextFrame.elements[0].matrix;
                        var perAddMatrix = endMatrix.sub(starMatrix).div(frame.duration);
                        var deltaMatrix = perAddMatrix.multi(currentFrame-frame.index);
                        matrix = starMatrix.add(deltaMatrix);
                    }
                    // TODO
                    // set child name
                    if ("movie clip" == instance.symbolType ||
                        "" == instance.symbolType) {

                        var item = cast(instance.libraryItem, DOMSymbolItem);

                        if (!Std.is(item, DOMSymbolItem)) {
                            throw '现在我还不清楚是不是只能是SymbolItem';
                        }

                        var displayObject = new MovieClip(item.timeline);
                        if (null != instance.name)
                            displayObject.name = instance.name;
                        displayObject.transform.matrix = matrix.toFlashMatrix();
                        addChild(displayObject);
                    } else if ("button" == instance.symbolType) {
                        var displayObject = new ButtonInstance(instance);
                        if (null != instance.name)
                            displayObject.name = instance.name;
                        displayObject.transform.matrix = matrix.toFlashMatrix();
                        addChild(displayObject);
                    }
                } else if (Std.is(element, DOMText)) {
                    var instance = cast(element, DOMText);
                    var displayObject = new TextInstance(instance);
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    addChild(displayObject);
                }
            }
        }
    }

    // override public function getChildByName(name:String):Sprite
    // {
    //     return 
    // }


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