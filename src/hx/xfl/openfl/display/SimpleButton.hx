package hx.xfl.openfl.display;

import flash.events.MouseEvent;
import hx.xfl.openfl.MovieClipFactory;
import hx.xfl.openfl.display.MovieClip;

class SimpleButton extends MovieClip
{

    public function new()
    {
        super();
        gotoAndStop(1);
        addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
        addEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, __onMouseOut);
    }

    function __onMouseOver(?e)
    {
        gotoAndStop(2);
    }

    function __onMouseOut(?e)
    {
        gotoAndStop(1);
    }

    function __onMouseDown(?e)
    {
        addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
        gotoAndStop(3);
    }

    function __onMouseUp(?e)
    {
        removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
        gotoAndStop(4);
        gotoAndStop(1);
    }
}