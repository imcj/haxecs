package hx.xfl.openfl.display;

import flash.events.Event;
import hx.geom.Matrix;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.motion.Property;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMShape;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.openfl.ShapeInstance;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.SimpleButton;

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

    function createBitmapInstance(bitmap_instance:DOMBitmapInstance)
    {
        var bitmapItem = cast(bitmap_instance.libraryItem, DOMBitmapItem);
        var bitmap = new BitmapInstance(
            bitmapItem,
            domTimeLine.document.assets.getBitmapDataWithBitmapItem(bitmapItem),
            PixelSnapping.AUTO, true);
        bitmap.transform.matrix = bitmap_instance.matrix.toFlashMatrix();
        
        if (null != bitmap_instance.name)
            bitmap.name = bitmap_instance.name;

        return bitmap;
    }

    function displayFrame():Void
    {
        freeChildren();

        var frame;
        var className:Class<Dynamic>;
        for (layer in domTimeLine.getLayersIterator(false)) {
            frame = layer.getFrameAt(currentFrame);
            if (frame == null) continue;
            for (element in frame.getElementsIterator()) {
                if (Std.is(element, DOMBitmapInstance)) {
                    var bitmap_instance = cast(element, DOMBitmapInstance);
                    addChild(createBitmapInstance(bitmap_instance));
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
                    }else if (frame.tweenType == "motion object") {
                        var keyFrames = frame.animation.PropertyContainers;
                        var basic = keyFrames.get("headContainer").children.get("Basic_Motion");
                        var xKeys = cast(basic.children.get("Motion_X"), Property).getStarEnd(currentFrame);
                        if (xKeys.length == 1) {
                            matrix.tx += xKeys[0].anchor.x;
                        }else if(xKeys.length > 1) {
                            var deltaX = xKeys[1].anchor.y - xKeys[0].anchor.y;
                            var deltaFrame = Std.int((xKeys[1].timevalue - xKeys[0].timevalue) / 1000);
                            matrix.tx += deltaX / deltaFrame;
                        }
                        var yKeys = cast(basic.children.get("Motion_Y"), Property).getStarEnd(currentFrame);
                        if (yKeys.length == 1) {
                            matrix.ty += xKeys[0].anchor.y;
                        }else if (yKeys.length > 1) {
                            var deltaY = yKeys[1].anchor.y - yKeys[0].anchor.y;
                            var deltaFrame = Std.int((yKeys[1].timevalue - yKeys[0].timevalue) / 1000);
                            matrix.ty += deltaY / deltaFrame;
                        }
                        var rKeys = cast(basic.children.get("Rotation_Z"), Property).getStarEnd(currentFrame);
                        if (rKeys.length == 1) {
                            matrix.rotate(rKeys[0].anchor.y * 180 / Math.PI);
                        }else if (rKeys.length > 1) {
                            var deltaR = rKeys[1].anchor.y - rKeys[0].anchor.y;
                            var deltaFrame = Std.int((rKeys[1].timevalue - rKeys[0].timevalue) / 1000);
                            matrix.rotate(deltaR / deltaFrame * 180 / Math.PI);
                        }
                    }
                    
                    if ("movie clip" == instance.symbolType ||
                        "" == instance.symbolType ||
                        "graphic" == instance.symbolType) {

                        var item = cast(instance.libraryItem, DOMSymbolItem);

                        if (!Std.is(item, DOMSymbolItem)) {
                            throw '现在我还不清楚是不是只能是SymbolItem';
                        }

                        var displayObject:MovieClip;
                        if (null != instance.libraryItem.linkageClassName) {
                            displayObject = Type.createInstance(Type.resolveClass(instance.libraryItem.linkageClassName), [item.timeline]);
                        } else
                            displayObject = new MovieClip(item.timeline);
                        if (null != instance.name)
                            displayObject.name = instance.name;
                        displayObject.transform.matrix = matrix.toFlashMatrix();
                        addChild(displayObject);
                    } else if ("button" == instance.symbolType) {
                        var button:Sprite;
                        if (null != instance.libraryItem.linkageClassName) {
                            className = Type.resolveClass(instance.libraryItem.linkageClassName);
                            button = Type.createInstance(className, [instance]);
                        } else
                            button = new SimpleButton(instance);
                        if (null != instance.name)
                            button.name = instance.name;
                        button.transform.matrix = matrix.toFlashMatrix();
                        addChild(button);
                    }
                } else if (Std.is(element, DOMText)) {
                    var instance = cast(element, DOMText);
                    var displayObject = new TextInstance(instance);
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    addChild(displayObject);
                } else if (Std.is(element, DOMShape)) {
                    var instance = cast(element, DOMShape);
                    var displayObject = new ShapeInstance(instance);
                    addChild(displayObject);
                }
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