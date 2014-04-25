package;


import hx.xfl.openfl.MovieClipFactory;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        trace("hello");
        var document = hx.xfl.XFLDocument.open("assets/shape");
        trace(document);
        var movieClip = MovieClipFactory.create(document.timeLines);
        addChild(movieClip);
    }
}