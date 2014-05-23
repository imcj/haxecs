package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.Matrix;
import hx.xfl.DOMAnimationCore;
import hx.xfl.DOMElement;
import hx.xfl.DOMFrame;
import hx.xfl.motion.KeyFrame;
import hx.xfl.motion.Property;
import hx.xfl.motion.PropertyContainer;

class MotionObject
{
    var domFrame:DOMFrame;
    var target:DOMElement;

    public function new(target, domFrame)
    {
        this.target = target;
        this.domFrame = domFrame;
    }
    
    public function getCurrentMatrix(currentFrame:Int):Matrix
    {
        var matrix = target.matrix.clone();
        var x = motion(matrix, "Motion_X", currentFrame);
        var y = motion(matrix, "Motion_Y", currentFrame);
        var r = motion(matrix, "Rotation_Z", currentFrame);
        
        if (x != null) matrix.tx += x;
        if (y != null) matrix.ty += y;
        if (r != null) matrix.rotate(r*Math.PI/180);
        
        return matrix;
    }
    
    function motion(matrix:Matrix, name:String, currentFrame:Int):Null<Float>
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return null;
        var property = getProperty(name);
        
        var keys = property.getStarEnd(currentFrame);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = keys[0].anchor.y;
            var c = keys[1].anchor.y - keys[0].anchor.y;
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            return easeQuadPercent(t, b, c, d, p);
        }
        
        return null;
    }
    
    function easeQuadPercent(t:Float, b:Float, c:Float, d:Float, p:Float):Float
    {
        if (p == 0) return c * t / d + b;
        if (p < 0) return c * (t/=d) * (t * (-p) + (1 + p)) + b;
        return c * (t/=d) * ((2 - t) * p +(1 - p)) + b;
    }

    public function getContainers(name:String):Map<String, PropertyContainer>
    {
        var head = domFrame.animation.PropertyContainers.get(name);
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