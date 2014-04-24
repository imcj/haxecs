package hx.xfl.openfl;

import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import hx.geom.Point;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMLayer;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.SimpleButton;

class Render
{
    static var instance(get, null):Render;
    static function get_instance():Render
    {
        if (instance == null) {
            instance = new Render();
        }
        return instance;
    }

    var mvTimelines:Map<MovieClip, Array<DOMTimeLine>>;

    public function new()
    {
        mvTimelines = new Map();
        init(); 
    }

    function init():Void 
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, render);
    }
    
    function render(e:Event):Void
    {
        for (mv in instance.mvTimelines.keys()) {
            if(mv.isPlaying)displayFrame(mv, mv.currentFrame);
        }
    }

    function displayFrame(mv:MovieClip, frameIndex:Int):Void 
    {
        mv.removeChildren();
        var timelines = mvTimelines.get(mv);
        var domTimeLine = getTimeline(timelines, mv.currentScene);
        if (domTimeLine == null) return;
        
        var maskDoms:Map<Int, DOMLayer> = new Map();
        var masklayers:Array<Array<DisplayObject>> = [];
        var maskNums = [];
        var numLayer = 0;
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            if ("mask" == domLayer.layerType) {
                maskDoms.set(numLayer, domLayer);
            }else {
                var layer = displayLayer(domLayer, mv, frameIndex, domTimeLine);
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
                displayLayer(dom, mask, frameIndex, domTimeLine);
                o.mask = mask;
                mv.addChild(mask);
            }
            n++;
        }
        mv.nextFrame();
    }

    function displayLayer(domLayer:DOMLayer, parent:Sprite, currentFrame:Int, line:DOMTimeLine):Array<DisplayObject> 
    {
        var className:Class<Dynamic>;
        var layer:Array<DisplayObject> = [];
        var frame = domLayer.getFrameAt(currentFrame);
        if (frame == null) return null;
        for (element in frame.getElementsIterator()) {
            if (Std.is(element, DOMBitmapInstance)) {
                var bitmap_instance = cast(element, DOMBitmapInstance);
                var bitmap = createBitmapInstance(bitmap_instance, line);
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
                        displayObject = MovieClipFactory.create(item.timelines);
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    displayObject.transform.matrix = matrix.toFlashMatrix();
                    if (instance.silent) {
                        displayObject.mouseEnabled = false;
                        displayObject.mouseChildren = false;
                    }
                    if (instance.forceSimple) {
                        displayObject.mouseChildren = false;
                    }
                    parent.addChild(displayObject);
                    layer.push(displayObject);
                } else if ("button" == instance.symbolType) {
                    var button:Sprite;
                    if (null != instance.libraryItem.linkageClassName) {
                        className = Type.resolveClass(instance.libraryItem.linkageClassName);
                        button = Type.createInstance(className, [instance]);
                    } else
                        button = MovieClipFactory.createButton(instance);
                    if (null != instance.name)
                        button.name = instance.name;
                    button.transform.matrix = matrix.toFlashMatrix();
                    button.mouseChildren = false;
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
                displayObject.transform.matrix = instance.matrix.toFlashMatrix();
                parent.addChild(displayObject);
                layer.push(displayObject);
            }
        }

        return layer;
    }

    static public function getTimeline(lines:Array<DOMTimeLine>, scene:Scene):DOMTimeLine 
    {
        for (line in lines) {
            if (line.name == scene.name) return line;
        }
        return null;
    }

    function createBitmapInstance(bitmap_instance:DOMBitmapInstance, domTimeLine:DOMTimeLine)
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

    static public function renderFrame(mv:MovieClip, frameIndex:Int):Void 
    {
        instance.displayFrame(mv, frameIndex);
    }

    static public function addMvTimeLine(mv:MovieClip, timelines:Array<DOMTimeLine>):Void 
    {
        instance.mvTimelines.set(mv, timelines);
        mv.gainScenes();
        instance.displayFrame(mv, mv.currentFrame);
    }

    static public function removeMvTimeLine(mv:MovieClip):Void 
    {
        instance.mvTimelines.remove(mv);
    }

    static public function getTimelines(mv:MovieClip):Array<DOMTimeLine> 
    {
        return instance.mvTimelines.get(mv);
    }

    static public function getScenes(mv:MovieClip):Array<Scene>
    {
        var scenes = [];
        var lines = getTimelines(mv);
        for (timeline in lines) {
            var s = new Scene();
            var name = timeline.name;
            var numFrames = 0;
            var labels = [];
            for (layer in timeline.layers) {
                if (numFrames < layer.totalFrames)
                    numFrames = layer.totalFrames;
                for (f in layer.frames) {
                    var name = f.name;
                    if(name != null)
                        labels.push(new FrameLabel(name,f.index));
                }
            }
            s.setValue(name, numFrames, labels);
            scenes.push(s);
        }
        return scenes;
    }
}