package;


import hx.xfl.openfl.display.MovieClip;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        var document = hx.xfl.XFLDocument.open("assets/openfl-logo");
        var movieClip = new MovieClip(document.timeLines);
        addChild(movieClip);

        trace(hx.Path.abspath("/a/../a/b/"));
    }
}