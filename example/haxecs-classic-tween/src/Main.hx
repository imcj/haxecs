package;


import hx.xfl.openfl.MovieClipFactory;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        var movieClip = XFL.load("assets/Classic");
        addChild(movieClip);
    }
}