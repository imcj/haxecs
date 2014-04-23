package hx.xfl.openfl;


class Scene
{
    public var labels(default, null):Array <FrameLabel>;
    public var name(default, null):String;
    public var numFrames(default, null):Int;

    public function new()
    {
        labels = [];
        name = null;
        numFrames = 0;
    }

    public function setValue(name, numFrames, labels):Void 
    {
        this.name = name;
        this.numFrames = numFrames;
        this.labels = labels;
    }
}