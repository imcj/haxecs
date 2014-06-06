package hx.geom;

class ColorTransform{

    public var alphaMultiplier:Float;
    public var alphaOffset:Float;
    public var blueMultiplier:Float;
    public var blueOffset:Float;
    public var color:Int;
    public var greenMultiplier:Float;
    public var greenOffset:Float;
    public var redMultiplier:Float;
    public var redOffset:Float;

    public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0, greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void
    {
        this.redMultiplier = redMultiplier;
        this.greenMultiplier = greenMultiplier;
        this.blueMultiplier = blueMultiplier;
        this.alphaMultiplier = alphaMultiplier;
        this.redOffset = redOffset;
        this.greenOffset = greenOffset;
        this.blueOffset = blueOffset;
        this.alphaOffset = alphaOffset;
    }


    public function concat(second:ColorTransform):Void
    {
        redMultiplier += second.redMultiplier;
        greenMultiplier += second.greenMultiplier;
        blueMultiplier += second.blueMultiplier;
        alphaMultiplier += second.alphaMultiplier;
    }
    
    public function get_color():Int
    {
        return (Std.int(redOffset) << 16) | (Std.int(greenOffset) << 8) | Std.int(blueOffset);
    }
    
    public function set_color(value:Int):Int
    {
        redOffset = (value >> 16) & 0xFF;
        greenOffset = (value >> 8) & 0xFF;
        blueOffset = value & 0xFF;

        redMultiplier = 0;
        greenMultiplier = 0;
        blueMultiplier = 0;

        return color;
    }
    
    public function clone():ColorTransform
    {
        var c = new ColorTransform();
        c.alphaMultiplier = alphaMultiplier;
        c.alphaOffset = alphaOffset;
        c.blueMultiplier = blueMultiplier;
        c.color = color;
        c.greenMultiplier = greenMultiplier;
        c.greenOffset = greenOffset;
        c.redMultiplier = redMultiplier;
        c.redOffset = redOffset;
        return c;
    }
    
    public function toFlashColorTransform():flash.geom.ColorTransform
    {
        return new flash.geom.ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
    }
}