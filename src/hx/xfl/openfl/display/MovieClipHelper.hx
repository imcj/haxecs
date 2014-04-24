package hx.xfl.openfl.display;

import flash.display.Sprite;

class MovieClipHelper
{
	var frameIndexes:Map<String, Map<Int, Bool>>;

	public function new(mc:Sprite)
	{
		frameIndexes = new Map();
		frameIndexes.set("", new Map());
	}

	public function addFrame(frame_index:Int, ?scene:Null<String>):Void
	{
		if (scene == null)
			scene = "";

		frameIndexes.get("").set(frame_index, true);
	}

	public function addFrames(frame_indexes:Array<Int>):Void
	{
		for (index in frame_indexes)
			addFrame(index);
	}
}