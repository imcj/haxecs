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
        var movieClip = new MovieClip(document.timeLines);
        addChild(movieClip);
        movieClip.gotoAndPlay(6, "场景 2");
        movieClip.gotoAndStop("jump", "Scene 1");
    }
}