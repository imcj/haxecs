package hx.xfl;

class DOMLayer
{
    public var timeLine:DOMTimeLine;
    public var autoNamed:String;
    public var current:Bool;
    public var color:String;
    public var isSelected:Bool;
    public var name:String;
    public var frames:Array<DOMFrame>;
    public var totalFrames:Int;

    public function new()
    {
        timeLine = null;
        autoNamed = null;
        current = false;
        color = null;
        isSelected = false;
        name = null;
        frames = [];
        totalFrames = 0;
    }

    public function addFrame(frame:DOMFrame):DOMLayer
    {
        frame.layer = this;
        frames.push(frame);
        return this;
    }

    public function getFramesIterator():Iterator<DOMFrame>
    {
        return frames.iterator();
    }
}