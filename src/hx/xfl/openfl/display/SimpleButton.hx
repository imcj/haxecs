package hx.xfl.openfl.display;

import flash.events.MouseEvent;
import hx.xfl.XFLDocument;

class SimpleButton extends MovieClip
{
    public var symbol:hx.xfl.DOMSymbolInstance;
    var __document:XFLDocument;

    public function new(symbol:DOMSymbolInstance)
    {
        this.symbol = symbol;
        __document  = symbol.frame.layer.timeLine.document;
        super(__document.getSymbol(symbol.libraryItem.name).timeline);

        this.transform.matrix = symbol.matrix.toFlashMatrix();
        gotoAndStop(0);
        addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
    }

    function __onMouseOver(?e)
    {
        gotoAndStop(1);
    }

    function __onMouseDown(?e)
    {
        addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
        gotoAndStop(2);
    }

    function __onMouseUp(?e)
    {
        removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
        gotoAndStop(3);
        gotoAndStop(0);
    }
}