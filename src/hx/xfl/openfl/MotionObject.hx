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

    var currentFrame:Int;

    public function new(target, domFrame)
    {
        this.target = target;
        this.domFrame = domFrame;
        this.currentFrame = 0;
    }
    
    public function getCurrentMatrix(currentFrame:Int):Matrix
    {
        this.currentFrame = currentFrame;
        var matrix = target.matrix.clone();
        motionX(matrix);
        motionY(matrix);
        motionRotation(matrix);
        motionScale(matrix);
        motionSkew(matrix);
        return matrix;
    }
    
    function motionX(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_X");
        var delta = nowS(property);
        
        matrix.tx += delta;
    }
    
    function motionY(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_Y");
        var delta = nowS(property);
        
        matrix.ty += delta;
    }
    
    function motionRotation(matrix:Matrix):Void 
    {
        var property = getProperty("Rotation_Z");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        var keys = property.keyFrames;
        var delta = keys[keys.length - 1].anchor.y - keys[0].anchor.y;
        var deltaFrame = keys[keys.length - 1].getFrameIndex() - keys[0].getFrameIndex();
        var pastFrame = animationFrame - keys[0].getFrameIndex();
        if(pastFrame < keys[keys.length-1].getFrameIndex())
            matrix.rotate(easeValue(delta * Math.PI / 180, deltaFrame, pastFrame));
        else 
            matrix.rotate(keys[keys.length - 1].anchor.y * Math.PI / 180);
    }
    
    function motionScale(matrix:Matrix):Void 
    {
        var propertyX = getProperty("Scale_X");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        var propertyY = getProperty("Scale_Y");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        var keysX = propertyX.keyFrames;
        var keysY = propertyY.keyFrames;
        var deltaX = keysX[keysX.length - 1].anchor.y - keysX[0].anchor.y;
        var deltaY = keysY[keysY.length - 1].anchor.y - keysY[0].anchor.y;
        var deltaFrame = keysX[keysX.length - 1].getFrameIndex() - keysX[0].getFrameIndex();
        var pastFrame = animationFrame - keysX[0].getFrameIndex();
        if(pastFrame < keysX[keysX.length-1].getFrameIndex())
            matrix.scale(1+easeValue(deltaX / 100, deltaFrame, pastFrame),1+easeValue(deltaY / 100, deltaFrame, pastFrame));
        else 
            matrix.scale(keysX[keysX.length - 1].anchor.y / 100, keysY[keysY.length - 1].anchor.y / 100);
    }
    
    function motionSkew(matrix:Matrix):Void 
    {
        var propertyX = getProperty("Skew_X");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        var propertyY = getProperty("Skew_Y");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        var keysX = propertyX.keyFrames;
        var keysY = propertyY.keyFrames;
        var deltaX = keysX[keysX.length - 1].anchor.y - keysX[0].anchor.y;
        var deltaY = keysY[keysY.length - 1].anchor.y - keysY[0].anchor.y;
        var deltaFrame = keysX[keysX.length - 1].getFrameIndex() - keysX[0].getFrameIndex();
        var pastFrame = animationFrame - keysX[0].getFrameIndex();
        if(pastFrame < keysX[keysX.length-1].getFrameIndex())
            matrix.skew(easeValue(deltaX / 100, deltaFrame, pastFrame),easeValue(deltaY / 100, deltaFrame, pastFrame));
        else 
            matrix.skew(keysX[keysX.length - 1].anchor.y / 100, keysY[keysY.length - 1].anchor.y / 100);
    }

    //flash中的缓动处理
    public function easeValue(delta:Float, deltaFrame:Int, pastFrame:Int):Float
    {
        var s = domFrame.animation.strength;
        if (s > 0) {
            var v0 = delta / deltaFrame * (1 + s / 100);
            var a = -v0/deltaFrame;
            return v0 * pastFrame + a * pastFrame * pastFrame / 2;
        }else if (s < 0) {
            var v0 = delta / deltaFrame * (1 + s / 100);
            var a = (delta - v0 * deltaFrame) * 2 / (deltaFrame * deltaFrame);
            var t = pastFrame;
            return  v0 * pastFrame + a * pastFrame * pastFrame / 2;
        }else {
            return delta / deltaFrame * pastFrame;
        }
    }
    
    function nowS(property:Property):Float 
    {
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return 0;
        
        var keys = property.keyFrames;
        var pastFrame = animationFrame - keys[0].getFrameIndex();
        
        var alls = allS(keys);
        var allt = allT(keys);
        var a = acceleration(alls, allt, domFrame.animation.strength);
        var keys = property.getStarEnd(currentFrame);
        var v0 = keyFrameVelocity(alls, allt, domFrame.animation.strength, keys[0].getFrameIndex());
        var delta = displacement(v0, a, currentFrame-keys[0].getFrameIndex());
        
        return delta;
    }
    
    function acceleration(s:Float, t:Int, strength:Float):Float 
    {
        if (strength > 0) {
            var v0 = s / t * (1 + strength / 100);
            return -v0 / t;
        }else if (strength < 0) {
            var v0 = s / t * (1 + strength / 100);
            return (s - v0 * t) * 2 / (t * t);
        }else {
            return 0;
        }
    }
    
    function displacement(v0:Float, a:Float, t:Int):Float
    {
        return v0 * t + a * t * t / 2;
    }
    
    function keyFrameVelocity(alls:Float, allt:Int, strength:Float, frameIndex:Int):Float 
    {
        var v0 = alls / allt * (1 + strength / 100);
        var a = acceleration(alls, allt, strength);
        return v0 + a * frameIndex;
    }
    
    function allS(keyFrames:Array<KeyFrame>):Float
    {
        return keyFrames[keyFrames.length - 1].anchor.y - keyFrames[0].anchor.y;
    }
    
    function allT(keyFrames:Array<KeyFrame>):Int
    {
        return keyFrames[keyFrames.length - 1].getFrameIndex() - keyFrames[0].getFrameIndex();
    }
    
    function targetFrame(keyFrames:Array<KeyFrame>):KeyFrame
    {
        var frame = null;
        for (i in keyFrames) {
            if (currentFrame < i.getFrameIndex()) frame = i;
        }
        return frame;
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