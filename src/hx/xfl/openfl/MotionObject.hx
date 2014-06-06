package hx.xfl.openfl;
import flash.display.DisplayObject;
import hx.geom.ColorTransform;
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
        
        var x = motion("Motion_X", currentFrame);
        var y = motion("Motion_Y", currentFrame);
        var r = motion("Rotation_Z", currentFrame);
        var scx = motion("Scale_X", currentFrame);
        var scy = motion("Scale_Y", currentFrame);
        var skx = motion("Skew_X", currentFrame);
        var sky = motion("Skew_X", currentFrame);
        
        if (x != null) matrix.tx += x;
        if (y != null) matrix.ty += y;
        if (r != null) matrix.rotate(r * Math.PI / 180);
        if (scx != null && scy != null) matrix.scale(scx / 100, scy / 100);
        if (skx != null && sky != null) matrix.skew(skx * Math.PI / 180, sky * Math.PI / 180);
        return matrix;
    }
    
    public function getCurrentAlpha(currentFrame:Int):Float 
    {
        var alpha = motion("Alpha_Amount", currentFrame);
        if (alpha != null) return alpha/100;
        else return 1;
    }
    
    public function getCurrentColorTransform(currentFrame:Int):ColorTransform
    {
        var colorTransform = target.colorTransform.clone();
        
        var rm = motion("AdvClr_R_Pct", currentFrame);
        var ro = motion("AdvClr_R_Offset", currentFrame);
        var gm = motion("AdvClr_G_Pct", currentFrame);
        var go = motion("AdvClr_G_Offset", currentFrame);
        var bm = motion("AdvClr_B_Pct", currentFrame);
        var bo = motion("AdvClr_B_Offset", currentFrame);
        var am = motion("AdvClr_A_Pct", currentFrame);
        var ao = motion("AdvClr_A_Offset", currentFrame);
        
        var bright = motion("Brightness_Amount", currentFrame);
        
        var tc = motionColor("Tint_Color", currentFrame);
        var ta = motion("Tint_Amount", currentFrame);
        
        if (rm != null) colorTransform.redMultiplier = rm/100;
        if (ro != null) colorTransform.redOffset = ro;
        if (gm != null) colorTransform.greenMultiplier = gm/100;
        if (go != null) colorTransform.greenOffset = go;
        if (bm != null) colorTransform.blueMultiplier = bm/100;
        if (bo != null) colorTransform.blueOffset = bo;
        if (am != null) colorTransform.alphaMultiplier = am/100;
        if (ao != null) colorTransform.alphaOffset = ao;
        
        if (bright != null) {
            colorTransform.redOffset = bright / 100 * 255;
            colorTransform.greenOffset = bright / 100 * 255;
            colorTransform.blueOffset = bright / 100 * 255;
        }
        
        if (ta != null) {
            var r = Std.int(tc) >> 16;
            var g = Std.int(tc) >> 8 & 0xFF;
            var b = Std.int(tc) & 0xFF;
            colorTransform.redMultiplier = r/255;
            colorTransform.greenMultiplier = g/255;
            colorTransform.blueMultiplier = b/255;
            colorTransform.redOffset = ta/100*255;
            colorTransform.greenOffset = ta/100*255;
            colorTransform.blueOffset = ta/100*255;
        }
        
        return colorTransform;
    }
    
    function motion(name:String, currentFrame:Int):Null<Float>
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return null;
        var property = getProperty(name);
        if (property == null) return null;
        
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
    
    function motionValue(name:String, currentFrame:Int):Null<Float>
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return null;
        var property = getProperty(name);
        if (property == null) return null;
        
        var keys = property.getStarEnd(animateTime);
        if (keys.length > 1) {
            var t = animateTime-keys[0].getFrameIndex();
            var b = Std.parseInt(keys[0].value);
            var c = Std.parseInt(keys[1].value) - Std.parseInt(keys[0].value);
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            return easeQuadPercent(t, b, c, d, p);
        }
        
        return null;
    }
    
    function motionColor(name:String, currentFrame:Int):Null<Int>
    {
        var animateTime = currentFrame-domFrame.index;
        if (animateTime <= 0) return null;
        var property = getProperty(name);
        if (property == null) return null;
        
        var keys = property.getStarEnd(animateTime);
        if (keys.length > 1) {
            var c0 = Std.parseInt(keys[0].value);
            var c1 = Std.parseInt(keys[1].value);
            var r0 = c0 >> 16;
            var g0 = c0 >> 8 & 0xFF;
            var b0 = c0 & 0xFF;
            var r1 = c1 >> 16;
            var g1 = c1 >> 8 & 0xFF;
            var b1 = c1 & 0xFF;
            var t = animateTime-keys[0].getFrameIndex();
            var d = keys[1].getFrameIndex() - keys[0].getFrameIndex();
            var p = domFrame.animation.strength / 100;
            var cr = r1 - r0;
            var cg = g1 - g0;
            var cb = b1 - b0;
            var r = Std.int(easeQuadPercent(t, r0, cr, d, p))<<16;
            var g = Std.int(easeQuadPercent(t, g0, cg, d, p))<<8;
            var b = Std.int(easeQuadPercent(t, b0, cb, d, p));
            return r | g | b;
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
                if (Std.is(p, PropertyContainer)) {
                    var pc = cast(p, PropertyContainer);
                    for (pcc in pc.children) {
                        if (name == pcc.id) return cast(pcc);
                    }
                }
            }
        }
        return null;
    }
}