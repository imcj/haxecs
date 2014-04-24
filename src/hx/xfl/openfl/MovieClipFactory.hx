package hx.xfl.openfl;
import hx.xfl.DOMTimeLine;
import flash.display.MovieClip;

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
        Render.instance.addMvTimeLine(mv , lines);
        mv.gainScenes();
        return mv;
    }
}