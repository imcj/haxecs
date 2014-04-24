package hx.xfl.openfl;
import flash.events.Event;
import flash.Lib;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;

class Render
{
    static public var instance(get, null):Render;
    static function get_instance():Render
    {
        if (instance == null) {
            instance = new Render();
        }
        return instance;
    }

    var mvTimelines:Map<Dynamic, Array<DOMTimeLine>>;

    public function new()
    {
        timelines = new Map();
        init();
    }

    function init():Void 
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, render);
    }
    
    function render(e:Event):Void
    {
        
    }

    public function addMvTimeLine(mv:MovieClip, timelines:Array<DOMTimeLine>):Void 
    {
        this.mvTimelines.set(mv, timelines);
    }

    public function removeMvTimeLine(mv:MovieClip):Void 
    {
        this.mvTimelines.remove(mv);
    }
}