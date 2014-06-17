package;

import flash.display.Sprite;


class Main extends Sprite
{
    public function new()
    {
        super();
        var movieClip = XFL.load("assets/gradient");
        addChild(movieClip);
    }
}