package hx.xfl.openfl.display;

import flash.events.MouseEvent;

class SimpleButton extends MovieClip
{
	public var symbol:hx.xfl.DOMSymbolInstance;

	public function new(symbol:DOMSymbolInstance)
	{
		this.symbol = symbol;
		var document = symbol.frame.layer.timeLine.document;
		super(document.getSymbol(symbol.libraryItem.name).timeline);

        this.transform.matrix = symbol.matrix.toFlashMatrix();

        gotoAndStop(0);

        // addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	function onMouseOver(?e)
	{
		gotoAndStop(1);
	}

	function onMouseDown(?e)
	{
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		gotoAndStop(2);
	}

	function onMouseUp(?e)
	{
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		gotoAndStop(3);
		gotoAndStop(0);
	}
}