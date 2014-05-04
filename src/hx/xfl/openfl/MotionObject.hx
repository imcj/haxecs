package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.Matrix;
import hx.xfl.DOMAnimationCore;
import hx.xfl.DOMElement;
import hx.xfl.DOMFrame;
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
        return matrix;
    }
    
    function motionX(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_X");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        for (frame in property.keyFrames) {
            if (animationFrame == frame.getFrameIndex()) 
                matrix.tx += frame.anchor.y;
        }
    }
    
    function motionY(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_Y");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        for (frame in property.keyFrames) {
            if (animationFrame == frame.getFrameIndex()) 
                matrix.tx += frame.anchor.y;
        }
    }

    public function animate(currentFrame:Int)
    {
        var matrix = target.matrix.clone();
        this.currentFrame = currentFrame;

        var xAdd = motion("Motion_X");
        var yAdd = motion("Motion_Y");
        if (xAdd.isAdd) matrix.tx += xAdd.v;
        else matrix.tx = target.matrix.tx+xAdd.v;
        if (yAdd.isAdd) matrix.ty += yAdd.v;
        else matrix.ty = target.matrix.ty+yAdd.v;
        var rotationAdd = motion("Rotation_Z");
        //matrix.rotate(rotationAdd);
        var scaleXAdd = motion("Scale_X");
        var scaleYAdd = motion("Scale_Y");
        //matrix.scale(scaleXAdd, scaleYAdd);
        var skewXAdd = motion("Skew_X");
        var skewYAdd = motion("Skew_Y");
        //matrix.skew(skewXAdd, skewYAdd);
        return matrix;
    }

    public function motion(propertyName:String): {v:Float, isAdd:Bool}
    {
        var motionResult:Dynamic = { };
        var addValue = 0.0;
        var property = getProperty(propertyName);
        var easeKeys = property.keyFrames;
        var easeDelta = easeKeys[easeKeys.length - 1].anchor.y - easeKeys[0].anchor.y;
        var easeDeltaFrame = Std.int((easeKeys[easeKeys.length - 1].timevalue - easeKeys[0].timevalue) / 1000);
        var keys = property.getStarEnd(currentFrame);
        if(1 < keys.length) {
            var delta = keys[1].anchor.y - keys[0].anchor.y;
            var deltaFrame = Std.int((keys[1].timevalue - keys[0].timevalue) / 1000);
            if (domFrame.animation.strength != 0) addValue = ease(easeDelta, easeDeltaFrame, currentFrame-Std.int(easeKeys[0].timevalue / 1000));
            else addValue = delta / deltaFrame;
            addValue *= (currentFrame-domFrame.index-Std.int(keys[0].timevalue / 1000));
            motionResult.isAdd = true;
        }else {
            addValue = keys[0].anchor.y;
            motionResult.isAdd = false;
        }

        if (~/Rotation/.match(propertyName)) addValue = addValue * Math.PI / 180;
        if (~/Scale/.match(propertyName)) addValue = (keys[0].anchor.y + addValue) / 100;
        if (~/Skew/.match(propertyName)) addValue = addValue * Math.PI / 180;

        motionResult.v = addValue;
        return motionResult;
    }

    //flash中的缓动处理
    public function ease(delta:Float, deltaFrame:Int, pastFrame:Int):Float 
    {
        var s = domFrame.animation.strength;
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