package;


import hx.xfl.openfl.display.MovieClip;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        trace("hello");
        var document = hx.xfl.XFLDocument.open("assets/Classic");
        trace(document);
        var movieClip = new MovieClip(document.timeLines);
        addChild(movieClip);
    }
}