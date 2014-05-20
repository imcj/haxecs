package;


import hx.xfl.openfl.MovieClipFactory;
import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        var xfl = XFL.load("assets/Tween");
        addChild(xfl);
    }
}