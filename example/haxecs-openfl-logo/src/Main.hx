package;

import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        var movieClip = XFL.load("assets/openfl-logo");
        addChild(movieClip);

        trace(hx.Path.abspath("/a/../a/b/"));
    }
}