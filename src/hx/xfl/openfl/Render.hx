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
        var mv = renderer.movieClip;
        instance.renderList.set(mv, renderer);
        mv.setScenes(getScenes(mv));
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

    static public function getScenes(mv:MovieClip):Array<Scene>
    {
        var scenes = [];
        var lines = getTimelines(mv);
        for (timeline in lines) {
            var s = new Scene();
            var name = timeline.name;
            var numFrames = 0;
            var labels = [];
            for (layer in timeline.layers) {
                if (numFrames < layer.totalFrames)
                    numFrames = layer.totalFrames;
                for (f in layer.frames) {
                    var name = f.name;
                    if(name != null)
                        labels.push(new FrameLabel(name,f.index));
                }
            }
            s.setValue(name, numFrames, labels);
            scenes.push(s);
        }
        return scenes;
    }
}