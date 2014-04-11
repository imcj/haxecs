package ;

import hx.xfl.XFLDocument;
import hx.xfl.openfl.display.MovieClip;

import flash.display.Sprite;

class HaxeCS extends Sprite
{
    public function new(path:String)
    {
        super();

        var doc = XFLDocument.open(path);
        var timeline = doc.getTimeLineAt(0);

        var mc = new MovieClip(timeline);
        addChild(mc);
    }
}