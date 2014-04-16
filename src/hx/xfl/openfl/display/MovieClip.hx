package hx.xfl.openfl.display;

import flash.display.DisplayObject;
import flash.events.Event;
import hx.geom.Matrix;
import hx.geom.Point;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMTimeLine;
import hx.xfl.motion.Property;
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
    public var currentFrame:Int;
    public var totalFrames:Int;
    public var isLoop:Bool;

    var timelines:Array<DOMTimeLine>;
    var timelinesMap:Map<String, DOMTimeLine>;
    var domTimeLine:DOMTimeLine;
    var currentSceneIndex:Int;


    public function new(timelines:Array<DOMTimeLine>)
    {
        super();
        name = '';
        isLoop = true;
        this.timelines = timelines;
        timelinesMap = new Map();
        this.totalFrames = 0;
        for (timeline in timelines) {
            timelinesMap.set(timeline.name, timeline);
            var sceneFrames = 0;
            for (layer in timeline.layers) {
                if (sceneFrames < layer.totalFrames) {
                    sceneFrames = layer.totalFrames;
                }
            }
            totalFrames += sceneFrames;
        }

        currentFrame = 0;
        changeToScene(0);
        play();
    }

    function onFrame(e:Event):Void 
    {
        nextFrame();
    }

    public function play():Void 
    {
        gotoAndPlay(currentFrame);
    }

    public function stop():Void 
    {
        gotoAndStop(currentFrame);
    }

    public function nextFrame():Void 
    {
        if (currentFrame < domTimeLine.totalFrames-1) 
        {
            currentFrame = currentFrame + 1;
            gotoFrame(currentFrame);
        }else if (timelines.length > 1) {
            if (currentSceneIndex < timelines.length - 1 || isLoop) {
                nextScene();
            }
        }
    }

    public function prevFrame():Void 
    {
        if (currentFrame > 0) 
        {
            currentFrame = currentFrame - 1;
            gotoFrame(currentFrame);
        }else if (timelines.length > 1) {
            if (currentSceneIndex > 0 || isLoop) {
                prevScene();
                currentFrame = domTimeLine.totalFrames - 1;
            }
        }
    }

    public function nextScene():Void 
    {
        if (currentSceneIndex < timelines.length-1) {
            changeToScene(currentSceneIndex + 1);
        }else {
            changeToScene(0);
        }
    }

    public function prevScene():Void 
    {
        if (currentSceneIndex > 0) {
            changeToScene(currentSceneIndex - 1);
        }else {
            changeToScene(timelines.length - 1);
        }
    }

    function changeToScene(scene:Dynamic):Void 
    {
        if (Std.is(scene,Int)) {
            domTimeLine = timelines[scene];
            currentSceneIndex = scene;
            currentFrame = 0;
            displayFrame();
        }else if (Std.is(scene,String)) {
            domTimeLine = timelinesMap.get(scene);
            currentSceneIndex = timelines.indexOf(domTimeLine);
            currentFrame = 0;
            displayFrame();
        }
    }

    public function gotoAndPlay(frame:Dynamic,?scene:String):Void 
    {
        if (scene != null) changeToScene(scene);
        if (Std.is(frame,Int)) {
            currentFrame = frame;
            gotoFrame(currentFrame);
            this.addEventListener(Event.ENTER_FRAME, onFrame);
        }else if(Std.is(frame,String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            gotoFrame(currentFrame);
            this.addEventListener(Event.ENTER_FRAME, onFrame);
        }
    }

    public function gotoAndStop(frame:Dynamic, ?scene:String):Void 
    {
        if (scene != null) changeToScene(scene);
        if (Std.is(frame, Int)) {
            currentFrame = frame;
            gotoFrame(currentFrame);
            this.removeEventListener(Event.ENTER_FRAME, onFrame);
        }else if (Std.is(frame, String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            gotoFrame(currentFrame);
            this.removeEventListener(Event.ENTER_FRAME, onFrame);
        }
    }

    function getLabelIndex(label:String):Int
    {
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            for (frame in domLayer.frames) {
                if (frame.name == label) return frame.index;
            }
        }
        return -1;
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
        var masklayers:Array<Array<DisplayObject>> = [];
        var maskNums = [];
        var numLayer = 0;
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            if ("mask" == domLayer.layerType) {
                maskDoms.set(numLayer, domLayer);
            }else {
                var layer = displayLayer(domLayer,this);
                if (domLayer.parentLayerIndex >= 0) {
                    masklayers.push(layer);
                    maskNums.push(domLayer.parentLayerIndex);
                }
            }
            numLayer++;
        }
        var n = 0;
        for (l in masklayers) {
            for (o in l) {
                var dom = maskDoms.get(numLayer - 1 - maskNums[n]);
                var mask = new Sprite();
                displayLayer(dom, mask);
                o.mask = mask;
                addChild(mask);
            }
            n++;
        }
    }

    function displayLayer(domLayer:DOMLayer, parent:Sprite):Array<DisplayObject> 
    {
        var className:Class<Dynamic>;
        var layer:Array<DisplayObject> = [];
        var frame = domLayer.getFrameAt(currentFrame);
        if (frame == null) return null;
        for (element in frame.getElementsIterator()) {
            if (Std.is(element, DOMBitmapInstance)) {
                var bitmap_instance = cast(element, DOMBitmapInstance);
                var bitmap = createBitmapInstance(bitmap_instance);
                parent.addChild(bitmap);
                layer.push(bitmap);
            } else if (Std.is(element, DOMSymbolInstance)) {
                var instance = cast(element, DOMSymbolInstance);

                // 动画
                var matrix = instance.matrix;
                if (frame.tweenType == "motion") {
                    var nextFrame = frame;
                    for (n in 0...domLayer.frames.length) {
                        if (domLayer.frames[n] == frame) {
                            nextFrame = domLayer.frames[n + 1];
                        }
                    }
                    var starMatrix = frame.elements[0].matrix;
                    var endMatrix = nextFrame.elements[0].matrix;
                    var perAddMatrix = endMatrix.sub(starMatrix).div(frame.duration);
                    var deltaMatrix = perAddMatrix.multi(currentFrame-frame.index);
                    matrix = starMatrix.add(deltaMatrix);
                }else if (frame.tweenType == "motion object") {
                    var motion = new MotionObject(instance, frame.animation);
                    var prePosition = new Point(matrix.tx, matrix.ty);
                    var preTransform = matrix.transformPoint(instance.transformPoint);
                    motion.animate(currentFrame);
                    //对形变中心引起的偏移做处理
                    var deltaPosition = new Point(matrix.tx - prePosition.x, matrix.ty - prePosition.y);
                    var nowTransform = matrix.transformPoint(instance.transformPoint);
                    var deltaTransform = new Point(nowTransform.x - preTransform.x, nowTransform.y - preTransform.y);
                    var revise = deltaPosition.sub(deltaTransform);
                    matrix.translate(revise);
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
                        displayObject = Type.createInstance(Type.resolveClass(instance.libraryItem.linkageClassName), [item.timelines]);
                    } else
                        displayObject = new MovieClip(item.timelines);
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    displayObject.transform.matrix = matrix.toFlashMatrix();
                    displayObject.mouseEnabled = !instance.silent;
                    displayObject.mouseChildren = !instance.hasAccessibleData;
                    parent.addChild(displayObject);
                    layer.push(displayObject);
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
                    parent.addChild(button);
                    layer.push(button);
                }
            } else if (Std.is(element, DOMText)) {
                var instance = cast(element, DOMText);
                var displayObject = new TextInstance(instance);
                if (null != instance.name)
                    displayObject.name = instance.name;
                parent.addChild(displayObject);
                layer.push(displayObject);
            } else if (Std.is(element, DOMShape)) {
                var instance = cast(element, DOMShape);
                var displayObject = new ShapeInstance(instance);
                parent.addChild(displayObject);
                layer.push(displayObject);
            }
        }

        return layer;
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
        var mv = new MovieClip(timelines);
        mv.gotoAndStop(currentFrame);
        return mv;
    }
}