package hx.xfl.openfl.display;

import flash.display.DisplayObject;
import flash.events.Event;
import hx.geom.Matrix;
import hx.geom.Point;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.motion.Property;
import hx.xfl.openfl.Layer;
import hx.xfl.openfl.MotionObject;

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

        var maskDoms:Map<Int, DOMLayer> = new Map();
        var masklayers = [];
        var maskNums = [];
        var numLayer = 0;
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            if ("mask" == domLayer.layerType) {
                maskDoms.set(numLayer, domLayer);
            }else {
                var layer = new Layer(domLayer);
                layer.displayFrame(currentFrame);
                addChild(layer);
                if (domLayer.parentLayerIndex > 0) {
                    masklayers.push(layer);
                    maskNums.push(domLayer.parentLayerIndex);
                }
            }
            numLayer++;
        }
        var n = 0;
        for (l in masklayers) {
            var dom = maskDoms.get(numLayer - 1 - maskNums[n]);
            var mask = new Layer(dom);
            mask.displayFrame(currentFrame);
            l.addChild(mask);
            l.mask = mask;
            n++;
        }
    }

    override public function getChildByName(name:String):DisplayObject
    {
        for (num in 0...numChildren) {
            var l = cast(super.getChildAt(num));
            var child = l.getChildByName(name);
            if (child != null) return child;
        }
        return null;
    }

    override public function getChildAt(index:Int):DisplayObject
    {
        var n = 0;
        for (num in 0...numChildren) {
            var l = cast(super.getChildAt(num));
            var child = l.getChildAt(index - n);
            if (child != null) return child;
            n += l.numChildren;
        }
        return super.getChildAt(index);
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

    public function clone():MovieClip
    {
        var mv = new MovieClip(domTimeLine);
        mv.gotoAndStop(currentFrame);
        return mv;
    }
}