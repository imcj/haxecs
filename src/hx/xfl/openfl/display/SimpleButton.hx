package hx.xfl.openfl.display;

import flash.events.Event;
import flash.events.MouseEvent;
import hx.xfl.openfl.MovieClipFactory;
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

        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }
    
    function onAdded(e:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        gotoAndStop(1);
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
        gotoAndStop(4);
        gotoAndStop(1);
    }
}