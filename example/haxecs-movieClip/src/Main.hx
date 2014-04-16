package;

import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import haxe.Timer;
import hx.xfl.openfl.display.MovieClip;
import flash.display.Sprite;


class Main extends Sprite
{
    var mv:MovieClip;

    public function new()
    {
        super();
        trace("hello");
        var document = hx.xfl.XFLDocument.open("assets/MovieClip");
        trace(document);
        mv = new MovieClip(document.timeLines);
        addChild(mv);

        var textField = new TextField();
        textField.text = "下一帧";
        addChild(textField);
        textField.addEventListener(MouseEvent.CLICK, nextFrame);

        var tfStop = new TextField();
        tfStop.text = "停止";
        tfStop.x = 100;
        addChild(tfStop);
        tfStop.addEventListener(MouseEvent.CLICK, stop);
    }
    
    function stop(e:MouseEvent):Void
    {
        mv.stop();
    }
    
    function nextFrame(e:MouseEvent):Void
    {
        mv.nextFrame();
    }
}