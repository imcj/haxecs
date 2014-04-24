package flash.display;

import flash.display.DisplayObject;
import flash.events.Event;
import hx.geom.Matrix;
import hx.geom.Point;
import hx.xfl.*;
import hx.xfl.motion.Property;
import hx.xfl.openfl.MotionObject;
import hx.xfl.openfl.*;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMShape;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.openfl.ShapeInstance;
import hx.xfl.openfl.display.BitmapInstance;
import hx.xfl.openfl.display.SimpleButton;

import flash.errors.RangeError;

class MovieClip extends Sprite
{
    public var currentFrame(default, null):Int;
    public var currentFrameLabel(get, null):String;
    public var currentLabels(get, null):Array<FrameLabel>;
    public var currentScene(default, null):Scene;
    public var totalFrames(default, null):Int;
    public var isPlaying(default, null):Bool;
    public var scenes(default, null):Array<Scene>;
    public var isLoop:Bool;

    public function new()
    {
        super();
        name = '';
        isLoop = true;
        currentFrame = 0;
        currentFrameLabel = null;
        currentLabels = [];
        currentScene = null;
        isPlaying = false;
        scenes = [];

        this.totalFrames = 0;

        if(totalFrames != 1) play();
    }

    public function gainScenes()
    {
        scenes = Render.getScenes(this);
        currentScene = scenes[0];
    }

    public function play():Void 
    {
        gotoAndPlay(currentFrame);
    }

    public function stop():Void 
    {
        gotoAndStop(currentFrame);
    }

    public function nextFrame():Void 
    {
        if (currentFrame < currentScene.numFrames) 
        {
            currentFrame = currentFrame + 1;
        }else {
            nextScene();
        }
    }

    public function prevFrame():Void 
    {
        if (currentFrame > 0) 
        {
            currentFrame = currentFrame - 1;
        }else {
            prevScene();
        }
    }

    public function nextScene():Void 
    {

    }

    public function prevScene():Void 
    {

    }

    function changeToScene(scene:Scene):Void 
    {
        currentScene = scene;
        currentFrame = 0;
    }

    public function gotoAndPlay(frame:Dynamic,?scene:Scene):Void 
    {
        if (scene != null) currentScene = scene;
        if (Std.is(frame, Int)) {
            currentFrame = frame;
            isPlaying = true;
        }
        if (Std.is(frame,String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            isPlaying = true;
        }
    }

    public function gotoAndStop(frame:Dynamic, ?scene:Scene):Void 
    {
        if (scene != null) currentScene = scene;
        if (Std.is(frame, Int)) {
            currentFrame = frame;
            isPlaying = false;
        }
        if (Std.is(frame,String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            isPlaying = false;
        }
    }

    function getLabelIndex(label:String):Int
    {
        var domTimeLine = Render.getTimeline(Render.getTimelines(this), currentScene);
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            for (frame in domLayer.frames) {
                if (frame.name == label) return frame.index;
            }
        }
        return -1;
    }

    function get_currentLabels():Array<FrameLabel>
    {
        return currentScene.labels;
    }

    function get_currentFrameLabel():String
    {
        var frameLabel = null;
        for (label in currentLabels) {
            if (currentFrame > label.frame) frameLabel = label.name;
        }
        return frameLabel;
    }

    public function clone():MovieClip
    {
        var mv = MovieClipFactory.create(Render.getTimelines(this));
        return mv;
    }
}