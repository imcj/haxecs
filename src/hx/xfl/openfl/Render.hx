package hx.xfl.openfl;
import flash.events.Event;
import flash.Lib;
import hx.xfl.DOMTimeLine;

class Render
{
    var timelines:Map<String, Array<DOMTimeLine>>;

    public function new()
    {
        init();
    }

    function init():Void 
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, render);
    }
    
    function render(e:Event):Void
    {
        
    }
}