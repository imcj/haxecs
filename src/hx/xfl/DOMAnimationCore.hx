package hx.xfl;
import hx.xfl.motion.PropertyContainer;

class DOMAnimationCore
{
    public var TimeScale:Int;
    public var Version:Int;
    public var duration:Int;

    public var PropertyContainers:Map<String, PropertyContainer>;

    public function new()
    {
        PropertyContainers = new Map();
    }
    
}