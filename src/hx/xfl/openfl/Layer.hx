package hx.xfl.openfl;

import hx.geom.Point;
import hx.xfl.DOMLayer;
import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.display.SimpleButton;

import flash.events.Event;
import flash.display.Sprite;
import flash.display.PixelSnapping;
import flash.errors.RangeError;

class Layer extends Sprite
{
    var dom:DOMLayer;

    public function new(dom:DOMLayer)
    {
        super();
        name = 'haxecs:layer:${dom.name}';

        this.dom = dom;
    }

    function createBitmapInstance(bitmap_instance:DOMBitmapInstance)
    {
        var bitmapItem = cast(bitmap_instance.libraryItem, DOMBitmapItem);
        var bitmap = new BitmapInstance(
            bitmapItem,
            dom.timeLine.document.assets.getBitmapDataWithBitmapItem(bitmapItem),
            PixelSnapping.AUTO, true);
        bitmap.transform.matrix = bitmap_instance.matrix.toFlashMatrix();
        
        if (null != bitmap_instance.name)
            bitmap.name = bitmap_instance.name;

        return bitmap;
    }

    public function displayFrame(currentFrame:Int):Void 
    {
        var className:Class<Dynamic>;
        var frame = dom.getFrameAt(currentFrame);
        if (frame == null) return;
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
                    for (n in 0...dom.frames.length) {
                        if (dom.frames[n] == frame) {
                            nextFrame = dom.frames[n + 1];
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
                        displayObject = Type.createInstance(Type.resolveClass(instance.libraryItem.linkageClassName), [item.timeline]);
                    } else
                        displayObject = new MovieClip(item.timeline);
                    if (null != instance.name)
                        displayObject.name = instance.name;
                    displayObject.transform.matrix = matrix.toFlashMatrix();
                    displayObject.mouseEnabled = !instance.silent;
                    displayObject.mouseChildren = !instance.hasAccessibleData;
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