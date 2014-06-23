package hx.xfl.openfl;

import flash.events.Event;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import hx.geom.Point;
import hx.xfl.IDOMElement;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMLayer;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.IElement;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.SimpleButton;
import hx.xfl.openfl.display.MovieClip;

using Lambda;
using logging.Tools;

typedef Combine = {
    var display:DisplayObject;
    var element:IDOMElement;
};

class DisplayObjectPool
{
    var container:DisplayObjectContainer;
    var previousFrame:Array<Combine>;

    public function new()
    {
    }

    public function fill(
        previousFrame:Array<Combine>,
        container:DisplayObjectContainer)
    {
        this.previousFrame = previousFrame;
        this.container = container;
    }

    public function clear()
    {
        if (null != previousFrame) {        
            for (c in previousFrame) {
                if (null != c.display && null != container)
                    container.removeChild(c.display);
            }
        }

        container = null;
    }

    function reusable(query:IDOMElement):Combine
    {
        var combine:Combine = null;
        var element:IDOMElement;
        if (null == previousFrame)
            return null;

        var size:Int = previousFrame.length;
        var found:Combine = null;
        for (i in 0...size) {
            combine = previousFrame[i];
            element = combine.element;
            if (Std.is(element, DOMText) && Std.is(query, DOMText)) {
                found = combine;
                break;
            } else if (Std.is(element, DOMShape) && Std.is(query, DOMShape)) {
                found = combine;
                break;
            } else if (Std.is(element, DOMInstance) && 
                Std.is(query, DOMInstance) &&
                cast(element, DOMInstance).libraryItem != null &&
                cast(query, DOMInstance).libraryItem.name ==
                cast(element, DOMInstance).libraryItem.name) {
                found = combine;
                break;
            }
        }

        if (null != found)
            previousFrame.remove(found);
        return found;
    }

    public function get(element:IDOMElement)
    {
        var found:Combine = reusable(element);
        if (null == found)
            return null;
        return found.display;
    }
}

class MovieClipRenderer
{
    public var movieClip:MovieClip;
    public var timelines:Array<DOMTimeLine>;

    var listening:Bool = false;
    var previousFrame:Array<Combine>;
    var currentFrames:Array<Combine>;
    var pool:DisplayObjectPool;

    public function new(movieClip:MovieClip, timelines:Array<DOMTimeLine>)
    {
        this.movieClip = movieClip;
        this.timelines = timelines;
        pool = new DisplayObjectPool();

        var labels = new Map<String, Map<String, Int>>();
        for (timeline in timelines) {
            var labelOfScene = new Map<String, Int>();
            labels.set(timeline.name, labelOfScene);
            for (layer in timeline.getLayersIterator()) {
                for (frame in layer.getFramesIterator()) {
                    if (null != frame.name && "" != frame.name)
                        labelOfScene.set(frame.name, frame.index);
                }
            }
        }

        var names = timelines.map(function(timeline) {
            return timeline.name;
            });

        debug("New renderer " + names.join(", "));

        movieClip.labels = labels;
        movieClip.renderer = this;
        movieClip.setScenes(getScenes());
        movieClip.nextFrame();

        if (movieClip.totalFrames > 1) {
            movieClip.play();
        }
    }

    function getScenes():Array<Scene>
    {
        var scenes = [];
        for (timeline in timelines) {
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

    function addedToStage(e)
    {
        movieClip.play();
    }

    function handleEnterFrame(e)
    {
        if (movieClip.totalFrames == 1)
            disableHandlerEnterFrame();

        if (movieClip.parent != null) {
            movieClip.nextFrame();
        }
    }

    public function enableHandlerEnterFrame()
    {
        if (listening)
            return;
        listening = true;
        movieClip.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
    }

    public function disableHandlerEnterFrame()
    {
        listening = false;
        movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
    }
    
    public function render():Void 
    {
        currentFrames = [];
        pool.fill(previousFrame, movieClip);
        displayFrame(movieClip, movieClip.currentFrame - 1);
        
        if (null != pool)
            pool.clear();

        previousFrame = currentFrames;

        movieClip.executeFrameScript();
    }
    
    function getCurrentTimeLine():DOMTimeLine
    {
        for (timeline in timelines)
            if (timeline.name == movieClip.currentScene.name)
                return timeline;

        return null;
    }

    function displayFrame(mv:MovieClip, frameIndex:Int):Void 
    {
        var timeline = getCurrentTimeLine();
        if (timeline == null) return;
        
        var maskDoms:Map<Int, DOMLayer> = new Map();
        var masklayers:Array<Array<DisplayObject>> = [];
        var maskNums = [];
        var numLayer = 0;
        for (domLayer in timeline.getLayersIterator(false)) {
            if ("mask" == domLayer.layerType) {
                maskDoms.set(numLayer, domLayer);
            } else {
                var layer = displayLayer(domLayer, mv, frameIndex, timeline);
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
                displayLayer(dom, mask, frameIndex, timeline);
                o.mask = mask;
                mv.addChild(mask);
            }
            n++;
        }
    }
    
    function displayLayer(domLayer:DOMLayer, parent:Sprite, currentFrame:Int,
        line:DOMTimeLine):Array<DisplayObject>
    {
        var classType:Class<Dynamic>;
        var layer:Array<DisplayObject> = [];
        var frame = domLayer.getFrameAt(currentFrame);
        if (frame == null) return null;

        var display_object:DisplayObject = null;
        var mc:MovieClip;
        var is_new:Bool;
        var item:DOMSymbolItem;

        for (element in frame.getElementsIterator()) {
            is_new = false;
            if (Std.is(element, DOMBitmapInstance)) {
                var bitmap_instance = cast(element, DOMBitmapInstance);
                display_object = pool.get(element);
                if (null == display_object) {
                    display_object = createBitmapInstance(bitmap_instance, line);
                    is_new = true;
                } else {
                    display_object.transform.matrix = 
                        bitmap_instance.matrix.toFlashMatrix();
                }
            } else if (Std.is(element, DOMSymbolInstance)) {
                var instance:DOMSymbolInstance = cast(element);
                item = cast(instance.libraryItem, DOMSymbolItem);

                // 动画
                var matrix = instance.matrix.clone();
                var colorTransform = instance.colorTransform.clone();
                var filters = instance.flashFilters;
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
                } else if (frame.tweenType == "motion object") {
                    var motion = new MotionObject(instance, frame);
                    var prePosition = new Point(matrix.tx, matrix.ty);
                    var preTransform = matrix.transformPoint(instance.transformPoint);
                    matrix = motion.getCurrentMatrix(currentFrame);
                    colorTransform = motion.getCurrentColorTransform(currentFrame);
                    filters = motion.getCurrentFilters(currentFrame);
                    //对形变中心引起的偏移做处理
                    var deltaPosition = new Point(matrix.tx - prePosition.x, matrix.ty - prePosition.y);
                    var nowTransform = matrix.transformPoint(instance.transformPoint);
                    var deltaTransform = new Point(nowTransform.x - preTransform.x, nowTransform.y - preTransform.y);
                    var revise = deltaPosition.sub(deltaTransform);
                    matrix.translate(revise);
                }

                mc = cast(pool.get(element), MovieClip);
                if (null == mc)
                    is_new = true;
                var linkageClassName = instance.libraryItem.linkageClassName;
                if (null == mc && null != linkageClassName) {
                    classType = Type.resolveClass(linkageClassName);
                    mc = Type.createInstance(classType, []);
                }
                
                if ("movie clip" == instance.symbolType ||
                    "" == instance.symbolType ||
                    "graphic" == instance.symbolType) {
                    if (is_new)
                        mc = new MovieClip();

                    if (instance.silent) {
                        mc.mouseEnabled = false;
                        mc.mouseChildren = false;
                    }
                    if (instance.forceSimple) {
                        mc.mouseChildren = false;
                    }
                } else if ("button" == instance.symbolType) {
                    if (is_new)
                        mc = new SimpleButton();
                    mc.mouseChildren = false;
                } else {
                    throw "Not implements";
                }

                new MovieClipRenderer(mc, [item.timeline]);
                display_object = mc;
                mc.transform.matrix = matrix.toFlashMatrix();
                mc.transform.colorTransform = colorTransform.toFlashColorTransform();
                mc.filters = filters;

            } else if (Std.is(element, DOMText)) {
                var instance:DOMText = cast(element, DOMText);
                var text:TextInstance = cast(pool.get(element));
                if (null == text) {
                    display_object = new TextInstance(instance);
                    is_new = true;
                } else {
                    text.render(cast(element));
                    display_object = text;
                }
            } else if (Std.is(element, DOMShape)) {
                ShapeInstance.draw(cast(element, DOMShape), parent);
            } else {
                throw "Not implements.";
            }

            if (null != element.name && "" != element.name)
                display_object.name = element.name;

            currentFrames.push({
                element: element,
                display: display_object,
            });

            if (display_object != null) {
                // if (is_new)
                    parent.addChild(display_object);
                layer.push(display_object);
            }
        }

        return layer;
    }

    public function createBitmapInstance(bitmap_instance:DOMBitmapInstance, 
        domTimeLine:DOMTimeLine)
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
}