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
        var scx = motion(matrix, "Scale_X", currentFrame);
        var scy = motion(matrix, "Scale_Y", currentFrame);
        var skx = motion(matrix, "Skew_X", currentFrame);
        var sky = motion(matrix, "Skew_X", currentFrame);
        
        if (x != null) matrix.tx += x;
        if (y != null) matrix.ty += y;
        if (r != null) matrix.rotate(r * Math.PI / 180);
        if (scx != null && scy != null) matrix.scale(scx / 100, scy / 100);
        if (skx != null && sky != null) matrix.skew(skx * Math.PI / 180, sky * Math.PI / 180);
        return matrix;
    }
    
    public function getCurrentAlpha(currentFrame:Int):Float 
    {
        var alpha = motion(null, "Alpha_ColorXform", currentFrame);
        if (alpha != null) return alpha/100;
        else return 1;
    }
    
    function motion(matrix:Matrix, name:String, currentFrame:Int):Null<Float>
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return null;
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
        
        return null;
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