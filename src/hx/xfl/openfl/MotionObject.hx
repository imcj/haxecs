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

    public function getMatrix(frame:Int):Matrix 
    {
        var matrix = new Matrix();
        
        return matrix;
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