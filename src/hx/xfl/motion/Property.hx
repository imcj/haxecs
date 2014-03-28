package hx.xfl.motion;
import hx.xfl.assembler.XFLBaseAssembler;

class Property
{
    public var enabled:Int;
    public var id:String;
    public var ignoreTimeMap:Int;
    public var readonly:Int;
    public var visible:Int;
    public var keyFrames:Array<KeyFrame>;

    public function new() 
    {
        keyFrames = [];
    }

    public function parse(data:Xml)
    {
        var assembler = new XFLBaseAssembler(null);
        assembler.fillProperty(this, data);
        for (element in data.elements()) {
            var keyFrame = new KeyFrame();
            keyFrame.parse(element);
            this.keyFrames.push(keyFrame);
        }
    }
}