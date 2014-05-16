package hx.xfl.openfl;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import hx.geom.Point;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMLayer;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.MovieClip;

class MovieClipRenderer
{
    var movieClip:MovieClip;
    public var timelines:Array<DOMTimeLine>;

    public function new(movieClip:MovieClip, timeline:Dynamic)
    {
        this.movieClip = movieClip;
        if (Std.is(timeline, DOMTimeLine)) this.timelines = [timeline];
        else if (Std.is(timeline, Array)) this.timelines = timeline;
        else throw "timeline 类型错误，需要是DOMTimeLine或者Array<DOMTimeLine>";
    }
    
    public function render():Void 
    {
        displayFrame(movieClip, movieClip.currentFrame);
    }
    
    function displayFrame(mv:MovieClip, frameIndex:Int):Void 
    {
        mv.removeChildren();
        var domTimeLine = Render.getTimeline(timelines, mv.currentScene);
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
    }
    
    function displayLayer(domLayer:DOMLayer, parent:Sprite, currentFrame:Int, line:DOMTimeLine):Array<DisplayObject>
    {
        var className:Class<Dynamic>;
        var layer:Array<DisplayObject> = [];
        var frame = domLayer.getFrameAt(currentFrame);
        if (frame == null) return null;

        var display_object:DisplayObject = null;
        var mc:MovieClip;

        for (element in frame.getElementsIterator()) {

            if (Std.is(element, DOMBitmapInstance)) {
                var bitmap_instance = cast(element, DOMBitmapInstance);
                display_object = createBitmapInstance(bitmap_instance, line);
            } else if (Std.is(element, DOMSymbolInstance)) {
                var instance:DOMSymbolInstance = cast(element);

                // 动画
                var matrix = instance.matrix.clone();
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
                    var motion = new MotionObject(instance, frame);
                    var prePosition = new Point(matrix.tx, matrix.ty);
                    var preTransform = matrix.transformPoint(instance.transformPoint);
                    matrix = motion.getCurrentMatrix(currentFrame);
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
                    if (null != instance.libraryItem.linkageClassName) {
                        mc = Type.createInstance(Type.resolveClass(instance.libraryItem.linkageClassName), []);
                        MovieClipFactory.dispatchTimeline(mc, item.timeline);
                    } else
                        mc = MovieClipFactory.create(item.timeline);

                    mc.transform.matrix = matrix.toFlashMatrix();
                    display_object = mc;

                    if (instance.silent) {
                        mc.mouseEnabled = false;
                        mc.mouseChildren = false;
                    }
                    if (instance.forceSimple) {
                        mc.mouseChildren = false;
                    }
                } else if ("button" == instance.symbolType) {
                    if (null != instance.libraryItem.linkageClassName) {
                        className = Type.resolveClass(instance.libraryItem.linkageClassName);
                        display_object = Type.createInstance(className, []);
                        MovieClipFactory.dispatchTimeline(cast(display_object), instance);
                    } else
                        display_object = MovieClipFactory.createButton(instance);

                    mc = cast(display_object);
                    mc.transform.matrix = matrix.toFlashMatrix();
                    mc.mouseChildren = false;
                } else {
                    throw "Not implements";
                }
            } else if (Std.is(element, DOMText)) {
                var instance:DOMText = cast(element, DOMText);
                display_object = new TextInstance(instance);
            } else if (Std.is(element, DOMShape)) {
                var instance:DOMShape = cast(element);
                display_object = new ShapeInstance(cast(element, DOMShape));
                display_object.transform.matrix = 
                    instance.matrix.toFlashMatrix();
            } else {
                throw "Not implements.";
            }

            if (null != element.name && "" != element.name)
                display_object.name = element.name;

            parent.addChild(display_object);
            layer.push(display_object);
        }

        return layer;
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
}