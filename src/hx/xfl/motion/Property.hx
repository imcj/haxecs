package hx.xfl.motion;
import hx.xfl.assembler.XFLBaseAssembler;

class Property
{
    public var enabled:Int;
    public var id:String;
    public var ignoreTimeMap:Int;
    public var readonly:Int;
    public var visible:Int;
    public var TimeMapIndex:Int;
    public var keyFrames:Array<KeyFrame>;
    public var value:Int;

    public function new() 
    {
        keyFrames = [];
    }
    
    public function nextKey(keyFrame:KeyFrame):KeyFrame
    {
        return keyFrames[keyFrames.indexOf(keyFrame) + 1];
    }

    public function getStarEnd(pastFrames:Int):Array<KeyFrame>
    {
        var starEnd:Array<KeyFrame> = [];
        for (kf in keyFrames) {
            var keyIndex = Std.int(kf.timevalue / 1000);
            if (keyIndex == pastFrames) {
                starEnd.push(kf);
                break;
            }else if (keyIndex < pastFrames) {
                starEnd = [];
                starEnd.push(kf);
            }else if (keyIndex > pastFrames) {
                starEnd.push(kf);
                break;
            }
        }
        return starEnd;
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