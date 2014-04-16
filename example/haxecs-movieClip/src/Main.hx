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

        var tfNextFrame = new TextField();
        tfNextFrame.text = "下一帧";
        tfNextFrame.selectable = false;
        addChild(tfNextFrame);
        tfNextFrame.addEventListener(MouseEvent.CLICK, nextFrame);

        var tfStop = new TextField();
        tfStop.text = "停止";
        tfStop.x = 100;
        addChild(tfStop);
        tfStop.addEventListener(MouseEvent.CLICK, stop);

        var tfPlay = new TextField();
        tfPlay.text = "播放";
        tfPlay.x = 200;
        addChild(tfPlay);
        tfPlay.addEventListener(MouseEvent.CLICK, play);
    }

    function setButton(btn:TextField,name:String,x:Float,fun:MouseEvent->Void):Void 
    {
        btn.text = name;
        btn.selectable = false;
        btn.x = x;
        addChild(btn);
        btn.addEventListener(MouseEvent.CLICK, fun);
    }

    function play(e:MouseEvent):Void
    {
        mv.play();
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