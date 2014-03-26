package;


import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.Layer;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        trace("hello");
        var document = hx.xfl.XFLDocument.open("assets/shape");
        trace(document);
        var timeline = document.getTimeLine("Scene 1");
        var movieClip = new MovieClip(timeline);
        addChild(movieClip);
    }
}