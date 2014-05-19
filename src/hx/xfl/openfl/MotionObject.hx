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
        motionRotation(matrix);
        motionScale(matrix);
        motionSkew(matrix);
        return matrix;
    }
    
    function motionX(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_X");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        var keys = property.keyFrames;
        var delta = keys[keys.length - 1].anchor.y - keys[0].anchor.y;
        var deltaFrame = keys[keys.length - 1].getFrameIndex() - keys[0].getFrameIndex();
        var pastFrame = animationFrame - keys[0].getFrameIndex();
        if(pastFrame < keys[keys.length-1].getFrameIndex())
            matrix.tx += easeValue(delta, deltaFrame, pastFrame);
        else
            matrix.tx += keys[keys.length - 1].anchor.y;
    }
    
    function motionY(matrix:Matrix):Void 
    {
        var property = getProperty("Motion_Y");
        var animationFrame = currentFrame - domFrame.index;
        if (animationFrame == 0) return ;
        
        var keys = property.keyFrames;
        var delta = keys[keys.length - 1].anchor.y - keys[0].anchor.y;
        var deltaFrame = keys[keys.length - 1].getFrameIndex() - keys[0].getFrameIndex();
        var pastFrame = animationFrame - keys[0].getFrameIndex();
        if(pastFrame < keys[keys.length-1].getFrameIndex())
            matrix.ty += easeValue(delta, deltaFrame, pastFrame);
        else
            matrix.ty += keys[keys.length - 1].anchor.y;
        
        //var s = domFrame.animation.strength;
        //var vStart = delta / deltaFrame * (1 + Math.abs(s) / 100);
        //var a = vStart / deltaFrame;
        //if (s > 0) {
            //var start = null;
            //var end = null;
            //for (key in keys) {
                //if (pastFrame >= key.getFrameIndex())
                    //start = key;
            //}
            //if (start != null) {
                //end = property.nextKey(start);
                //if (end != null) {
                    //var v0 = vStart - a * pastFrame;
                    //if (end.anchor.y - start.anchor.y > 0)
                        //matrix.ty += v0 * pastFrame + a * pastFrame * pastFrame / 2;
                    //else
                        //matrix.ty += 2 * start.anchor.y - v0 * pastFrame - a * pastFrame * pastFrame / 2;
                //}
            //}
        //}
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
            addValue = ease(easeDelta, easeDeltaFrame, currentFrame-Std.int(easeKeys[0].timevalue / 1000));
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
            return delta / deltaFrame;
        }
    }
    
    public function easeValue(delta:Float, deltaFrame:Int, pastFrame:Int):Float
    {
        var s = domFrame.animation.strength;
        if (s > 0) {
            var v0 = delta / deltaFrame * (1 + s / 100);
            var a = -(delta - v0 * deltaFrame) * 2 / (deltaFrame * deltaFrame);
            var t = pastFrame;
            return v0 * t + a * t * t / 2;
        }else if (s < 0) {
            var v0 = delta / deltaFrame * (1 + s / 100);
            var a = (delta - v0 * deltaFrame) * 2 / (deltaFrame * deltaFrame);
            var t = pastFrame;
            return  v0 * pastFrame + a * t * t / 2;
        }else {
            return delta / deltaFrame * pastFrame;
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