package hx.xfl.openfl;

import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.display.SimpleButton;

class MovieClipFactory
{
    static public var instance(get, null):MovieClipFactory;
    static function get_instance():MovieClipFactory
    {
        if (instance == null) {
            instance = new MovieClipFactory();
        }
        return instance;
    }

    public function new()
    {
        if (instance != null) throw "MovieClipFactory是单列类";
    }

    static public function create(domTimeLine:Dynamic):MovieClip 
    {
        var lines = [];
        if (Std.is(domTimeLine, Array)) lines = domTimeLine;
        if (Std.is(domTimeLine, DOMTimeLine)) lines = [domTimeLine];
        var mv = new MovieClip();
        Render.addMvTimeLine(mv , lines);
        return mv;
    }

    static public function createButton(symbol:DOMSymbolInstance):SimpleButton
    {
        var document  = symbol.frame.layer.timeLine.document;
        var lines = document.getSymbol(symbol.libraryItem.name).timelines;
        var button = new SimpleButton();
        Render.addMvTimeLine(button, lines);
        return button;
    }

    static public function dispatchTimeline(mv:MovieClip, timeline:Dynamic):Void 
    {
        var lines = [];
        if (Std.is(timeline, Array)) lines = timeline;
        if (Std.is(timeline, DOMTimeLine)) lines = [timeline];
        if (Std.is(timeline, DOMSymbolInstance)) {
            var document  = timeline.frame.layer.timeLine.document;
            lines = document.getSymbol(timeline.libraryItem.name).timelines;
        }
        Render.addMvTimeLine(mv, lines);
    }
}