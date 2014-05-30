package hx.xfl.openfl.display;

import flash.display.Sprite;
import hx.xfl.openfl.MovieClipFactory;
import hx.xfl.openfl.Render;

using Lambda;

// TODO
// 整理注释
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

    var scripts:Map<String, Map<Int, Bool>>;
    var methods:Map<Int, Array<Void->Void>>;

    public function new()
    {
        super();
        name = '';
        isLoop = true;
        totalFrames = 0;

        currentFrame = 0;
        currentFrameLabel = null;
        currentLabels = [];
        currentScene = null;
        isPlaying = false;
        scenes = [];

        this.totalFrames = 0;
        scripts = new Map();
        methods = new Map();
    }

    function addFrame(index:Int, scene:String):Void
    {
        if (null == scripts.get(scene))
            scripts.set(scene, new Map<Int, Bool>());

        var indexes = scripts.get(scene);
        indexes.set(index, true);
    }

    public function addFrameScript(frame0:Int, script0:Void->Void,
         frame1:Int=-1, script1:Void->Void=null, frame2:Int=-1,
         script2:Void->Void=null, frame3:Int=-1, script3:Void->Void=null,
         frame4:Int=-1, script4:Void->Void=null, frame5:Int=-1,
         script5:Void->Void=null, frame6:Int=-1, script6:Void->Void=null,
         frame7:Int=-1, script7:Void->Void=null, frame8:Int=-1,
         script8:Void->Void=null, frame9:Int=-1, script9:Void->Void=null):Void
    {
        _addFrameScript(frame0, script0);
        _addFrameScript(frame1, script1);
        _addFrameScript(frame2, script2);
        _addFrameScript(frame3, script3);
        _addFrameScript(frame4, script4);
        _addFrameScript(frame5, script5);
        _addFrameScript(frame6, script6);
        _addFrameScript(frame7, script7);
        _addFrameScript(frame8, script8);
        _addFrameScript(frame9, script9);
    }

    inline function _addFrameScript(frame:Int, script:Void->Void):Void
    {
        if (null == script || frame == -1)
            return;

        var frame_methods:Array<Void->Void> = methods.get(frame);
        if (null == frame_methods) {
            frame_methods = [];
            methods.set(frame, frame_methods);
        }
        frame_methods.push(script);
    }

    inline function clearId(class_name:String):String
    {
        return ~/([^A-Za-z0-9_])/g.replace(class_name, "_");
    }

    public function setScenes(sceneArr:Array<Scene>):Void 
    {
        scenes = sceneArr;
        currentScene = scenes[0];
        for (s in scenes) {
            totalFrames += s.numFrames;
        }
        if (totalFrames != 1) play();
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
        if (currentFrame < currentScene.numFrames-1) 
        {
            currentFrame = currentFrame + 1;
            gotoFrame();
        }else {
            if(scenes.indexOf(currentScene) < scenes.length - 1 || isLoop) nextScene();
        }
    }

    public function prevFrame():Void 
    {
        if (currentFrame > 0) 
        {
            currentFrame = currentFrame - 1;
            gotoFrame();
        }else {
            prevScene();
            currentFrame = currentScene.numFrames - 1;
        }
    }
    
    function gotoFrame()
    {
        Render.renderMovieClip(this);
        executeFrameScript();
    }

    inline function executeFrameScript():Void
    {
        var scene_name = clearId(currentScene.name);
        var index = currentFrame;

        var indexes = scripts.get(scene_name);
        if (null != indexes) {

            var hasFrame = indexes.get(index);
            if (!(null == hasFrame || !hasFrame)) {
                Reflect.callMethod(this, '_haxecs_frame_${scene_name}_${index}', null);
            }
        }

        var frame_scripts = methods.get(currentFrame);
        if (null != frame_scripts) {
            for (script in frame_scripts)
                script();
        }
    }

    public function nextScene():Void 
    {
         var n = scenes.indexOf(currentScene);
         if (n + 1 < scenes.length) {
             changeToScene(scenes[n + 1]);
         }else {
             changeToScene(scenes[0]);
         }
    }

    public function prevScene():Void 
    {
         var n = scenes.indexOf(currentScene);
         if (n - 1 >= 0) {
             changeToScene(scenes[n - 1]);
         }else {
             changeToScene(scenes[scenes.length - 1]);
         }
    }

    function changeToScene(scene:Scene):Void 
    {
        currentScene = scene;
        currentFrame = 0;
        gotoFrame();
    }

    public function gotoAndPlay(frame:Dynamic,?scene:String):Void 
    {
        var nowScene = findScene(scene);
        if (nowScene != null) currentScene = nowScene;
        if (Std.is(frame, Int)) {
            currentFrame = cast(frame)-1;
            isPlaying = true;
        }
        if (Std.is(frame,String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            isPlaying = true;
        }
    }

    public function gotoAndStop(frame:Dynamic, ?scene:String):Void 
    {
        var nowScene = findScene(scene);
        if (nowScene != null) currentScene = nowScene;
        if (Std.is(frame, Int)) {
            currentFrame = cast(frame)-1;
            isPlaying = false;
            gotoFrame();
        }
        if (Std.is(frame,String)) {
            var i = getLabelIndex(frame);
            if (i >= 0) currentFrame = i;
            isPlaying = false;
            gotoFrame();
        }
    }

    function findScene(name:String):Scene
    {
        if (name == null) return null;
        for (s in scenes) {
            if (s.name == name) return s;
        }
        return null;
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