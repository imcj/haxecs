package;


import flash.display.Sprite;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.XFLDocument;

import logging.*;

class Main extends MovieClip
{
	public function new ()
	{
		super();

		var logger = Logging.getLogger("");
		logger.addHandler(new logging.handlers.SocketHandler("localhost:8800"));

		XFLDocument.open("assets/simplebutton").root(this);
	}
}