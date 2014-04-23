package ;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

class FrameLabel extends EventDispatcher
{
    public var name(default, null):String;
    public var frame(default, null):Int;

    public function new(name:String, frame:Int)
    {
        super();
    }
    
}