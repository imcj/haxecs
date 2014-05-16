package hx.xfl.openfl;

import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.Lib;

import hx.geom.Point;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.DOMBitmapItem;
import hx.xfl.DOMLayer;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.SimpleButton;

class Render
{
    static public var instance(get, null):Render;
    static function get_instance():Render
    {
        if (instance == null) {
            instance = new Render();
        }
        return instance;
    }

    var renderList:Map<MovieClip, MovieClipRenderer>;

    public function new()
    {
        renderList = new Map();
        init(); 
    }

    function init():Void 
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, render);
    }
    
    function render(e:Event):Void
    {
        for (mv in instance.renderList.keys()) {
            if (mv.isPlaying && mv.parent != null && mv.totalFrames != 1) {
                mv.nextFrame();
            }
        }
    }

    static public function getTimeline(lines:Array<DOMTimeLine>, scene:Scene):DOMTimeLine 
    {
        for (line in lines) {
            if (line.name == scene.name) return line;
        }
        return null;
    }

    static public function addRenderer(renderer:MovieClipRenderer):Void 
    {
        instance.renderList.set(renderer.movieClip, renderer);
        renderer.render();
    }

    static public function removeRenderer(mv:MovieClip):Void 
    {
        instance.renderList.remove(mv);
    }
    
    static public function renderMovieClip(mv:MovieClip):Void 
    {
        instance.renderList.get(mv).render();
    }

    static public function getTimelines(mv:MovieClip):Array<DOMTimeLine> 
    {
        return instance.renderList.get(mv).timelines;
    }
}