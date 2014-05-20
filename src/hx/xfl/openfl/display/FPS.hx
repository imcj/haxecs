package hx.xfl.openfl.display;

import flash.events.Event;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;

class FPS extends TextField
{
    public var fps:Int;
    var prev:Int;
    var times:Array<Float>;

    public function new() 
    {
        super();
        times = [];
        mouseEnabled = false;
        defaultTextFormat = new TextFormat (12, 0xffffff);
        addEventListener(Event.ENTER_FRAME, onEnter);
    }

    public function onEnter(e)
    {
        var now = Lib.getTimer () / 1000;
        times.push(now);
        while(times[0]<now-1)
            times.shift();
        fps = times.length;

        if (visible && prev != fps)
        {
            prev = fps;
            text = "FPS: " + fps;
        }
    }
}