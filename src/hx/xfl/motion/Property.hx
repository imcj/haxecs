package hx.xfl.motion;

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
    
}