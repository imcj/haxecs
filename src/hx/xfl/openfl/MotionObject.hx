package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.Matrix;
import hx.xfl.DOMAnimationCore;
import hx.xfl.DOMElement;
import hx.xfl.motion.Property;
import hx.xfl.motion.PropertyContainer;

class MotionObject
{
    var dom:DOMAnimationCore;
    var target:DOMElement;

    public function new(target, dom)
    {
        this.target = target;
        this.dom = dom;
    }

    public function animate(currentFrame:Int)
    {
        var matrix = target.matrix;
        
    }

    //flash中的缓动处理
    public function ease(delta:Float, deltaFrame:Int, pastFrame:Int):Float 
    {
        var s = dom.strength;
        if (s > 0) {
            var v0 = delta / deltaFrame * (1 + s / 100);
            var a = -v0 / deltaFrame;
            var t = pastFrame;
            return v0 + a * (2 * t -1) / 2;
        }else if (s < 0) {
            var v1 = delta / deltaFrame * (1 - s / 100);
            var a = v1 / deltaFrame;
            var t = pastFrame;
            return  a * (2 * t -1) / 2;
        }else {
            return 0;
        }
    }

    public function getContainers(name:String):Map<String, PropertyContainer>
    {
        var head = dom.PropertyContainers.get(name);
        if (null == head) return null;
        var containers = cast(head.children);
        return containers;
    }

    public function getProperty(name:String):Property 
    {
        var containers = getContainers("headContainer");
        for (c in containers) {
            for (p in c.children) {
                if (name == p.id) return cast(p);
            }
        }
        return null;
    }
}