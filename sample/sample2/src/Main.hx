package;


import flash.display.Sprite;


class Main extends Sprite
{
	public function new()
	{
		super();

		var document = hx.xfl.XFLDocument.open(
            "/Users/weicongju/Projects/hoohou/jewel/");
		for (layer in document.getTimeLineAt(0).getLayerIterator()) {
            for (frame in layer.getFramesIterator(false)) {
                for (element in frame.getElementsIterator()) {
                    
                }
            }
        }
	}
}