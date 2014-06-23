package;

import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import haxe.Timer;
import flash.display.Sprite;
import hx.xfl.openfl.display.MovieClip;


class Main extends Sprite
{
    var mv:MovieClip;

    public function new()
    {
        super();

        var document = hx.xfl.XFLDocument.open("assets/MovieClip");

        mv = new MovieClip();
        document.root(mv);
        addChild(mv);

        bulidButton("下一帧", 0, nextFrame);
        bulidButton("播放", 100, play);
        bulidButton("停止", 200, stop);
        bulidButton("下一场景", 300, nextScene);
        bulidButton("跳到场景1jump", 400, toLabel);
        bulidButton("跳到场景2播放", 500, toScene2);
        bulidButton("上一帧", 600, prevFrame);
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

    function toLabel(e:MouseEvent):Void 
    {
        mv.gotoAndPlay("jump", mv.scenes[0].name);
    }

    function toScene2(e:MouseEvent):Void
    {
        mv.gotoAndPlay(0, mv.scenes[1].name);
    }

    function toScene1(e:MouseEvent):Void
    {
        mv.gotoAndPlay(0, mv.scenes[1].name);
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

    function prevFrame(e:MouseEvent):Void
    {
        mv.prevFrame();
    }
}