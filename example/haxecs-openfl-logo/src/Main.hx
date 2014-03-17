package;


import hx.xfl.openfl.Layer;
import flash.display.Sprite;


class Main extends Sprite
{
	public function new()
	{
		super();
		var document = hx.xfl.XFLDocument.open("assets/openfl-logo");
        var timeline = document.getTimeLine("Scene 1");
        var layer = new Layer(timeline.getLayer("Layer 1"));
        addChild(layer);		

        trace(hx.Path.abspath("/a/../a/b/"));
	}
}