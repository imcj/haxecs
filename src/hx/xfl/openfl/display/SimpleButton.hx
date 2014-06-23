package hx.xfl.openfl.display;

import flash.events.Event;
import flash.events.MouseEvent;
import hx.xfl.openfl.display.MovieClip;

class SimpleButton extends MovieClip
{

    public function new()
    {
        super();
        addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
        addEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, __onMouseOut);
        addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);

        addFrameScript(0, function() {
            stop();
        });
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
        gotoAndStop(3);
    }

    function __onMouseUp(?e)
    {
        gotoAndStop(1);
    }
}