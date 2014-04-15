package;

import hx.xfl.openfl.display.MovieClip;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        trace("hello");
        var document = hx.xfl.XFLDocument.open("assets/MovieClip");
        trace(document);
        var timeline = document.getTimeLine("Scene 1");
        var movieClip = new MovieClip(timeline);
        addChild(movieClip);
    }
}