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
        return motion(currentFrame);
    }
    
    function motion(currentFrame:Int):Matrix 
    {
        var matrix = target.matrix.clone();
    
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return matrix;
        var property = getProperty("Motion_X");
        
        var keys = property.getStarEnd(currentFrame);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = matrix.tx + keys[0].anchor.y;
            var c = keys[1].anchor.y - keys[0].anchor.y;
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            matrix.tx = easeQuadPercent(t, b, c, d, p);
        }
        
        var property = getProperty("Motion_Y");
        
        var keys = property.getStarEnd(currentFrame);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = matrix.ty + keys[0].anchor.y;
            var c = keys[1].anchor.y - keys[0].anchor.y;
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            matrix.ty = easeQuadPercent(t, b, c, d, p);
        }
        
        var property = getProperty("Rotation_Z");
        
        var keys = property.getStarEnd(currentFrame);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = keys[0].anchor.y;
            var c = keys[1].anchor.y - keys[0].anchor.y;
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            matrix.rotate(easeQuadPercent(t, b, c, d, p)*Math.PI/180);
        }
        
        return matrix;
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