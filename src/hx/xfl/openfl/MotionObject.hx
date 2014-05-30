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
        
        matrix.tx += motion(matrix, "Motion_X", currentFrame);
        matrix.ty += motion(matrix, "Motion_Y", currentFrame);
        matrix.rotate(motion(matrix, "Rotation_Z", currentFrame)*Math.PI/180);
        matrix.scale(motion(matrix, "Scale_X", currentFrame)/100, motion(matrix, "Scale_Y", currentFrame)/100);
        matrix.skew(motion(matrix, "Skew_X", currentFrame)*Math.PI/180, motion(matrix, "Skew_Y", currentFrame)*Math.PI/180);
        
        return matrix;
    }
    
    function motion(matrix:Matrix, name:String, currentFrame:Int):Float
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return 0;
        var property = getProperty(name);
        
        var keys = property.getStarEnd(animateTime);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = keys[0].anchor.y;
            var c = keys[1].anchor.y - keys[0].anchor.y;
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            return easeQuadPercent(t, b, c, d, p);
            //var p0 = keys[0].anchor.y;
            //var p1 = keys[0].next.y;
            //var p2 = keys[1].anchor.y;
            //return easeBezier(t, d, p0, p1, p2);
        }
        
        return 0;
    }
    
    function easeQuadPercent(t:Float, b:Float, c:Float, d:Float, p:Float):Float
    {
        if (p == 0) return c * t / d + b;
        if (p < 0) return c * (t/=d) * (t * (-p) + (1 + p)) + b;
        return c * (t/=d) * ((2 - t) * p +(1 - p)) + b;
    }
    
    function easeBezier(t:Float, d:Float, p0:Float, p1:Float, p2:Float):Float 
    {
        return (t /= d) * t * p2 + (1 - t) * (1 - t) * p0 + 2 * t * (1 - t) * p1;
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