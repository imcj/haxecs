package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.Matrix;
import hx.xfl.DOMAnimationCore;
import hx.xfl.motion.Property;
import hx.xfl.motion.PropertyContainer;

class MotionObject
{
    public var dom:DOMAnimationCore;

    public function new(dom)
    {
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
        if (null == container) return null;
        var containers = head.children;
        return containers;
    }

    public function getProperty(name:String):Property 
    {
        for (up in dom.PropertyContainers) {
            for (container in up.children) {
                for (property in container.children) {
                    if (name == property.id) {
                        return property;
                    }
                }
            }
        }
        return null;
    }
}