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

        bulidButton("下一帧", 0, nextFrame);
        bulidButton("播放", 100, play);
        bulidButton("停止", 200, stop);
        bulidButton("下一场景", 300, nextScene);
    }

    function bulidButton(name:String,x:Float,fun:MouseEvent->Void):Void 
    {
        var btn = new TextField();
        btn.text = name;
        btn.selectable = false;
        btn.x = x;
        addChild(btn);
        btn.addEventListener(MouseEvent.CLICK, fun);
    }

    function nextScene(e:MouseEvent):Void 
    {
        mv.nextScene();
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