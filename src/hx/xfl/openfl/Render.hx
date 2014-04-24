package hx.xfl.openfl;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import hx.xfl.DOMTimeLine;
import flash.display.MovieClip;

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

    var mvTimelines:Map<Dynamic, Array<DOMTimeLine>>;

    public function new()
    {
        mvTimelines = new Map();
        init();
    }

    function init():Void 
    {
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, render);
    }
    
    function render(e:Event):Void
    {
        for (mv in mvTimelines.keys()) {
            displayFrame(mv);
        }
    }

    function displayFrame(mv:MovieClip):Void 
    {
        var timelines = mvTimelines.get(mv);
        var domTimeLine = getTimeline(timelines, mv.currentScene);

        var maskDoms:Map<Int, DOMLayer> = new Map();
        var masklayers:Array<Array<DisplayObject>> = [];
        var maskNums = [];
        var numLayer = 0;
        for (domLayer in domTimeLine.getLayersIterator(false)) {
            if ("mask" == domLayer.layerType) {
                maskDoms.set(numLayer, domLayer);
            }else {
                var layer = displayLayer(domLayer,this);
                if (domLayer.parentLayerIndex >= 0) {
                    masklayers.push(layer);
                    maskNums.push(domLayer.parentLayerIndex);
                }
            }
            numLayer++;
        }
        var n = 0;
        for (l in masklayers) {
            for (o in l) {
                var dom = maskDoms.get(numLayer - 1 - maskNums[n]);
                var mask = new Sprite();
                displayLayer(dom, mask);
                o.mask = mask;
                mv.addChild(mask);
            }
            n++;
        }
    }

    function getTimeline(lines:Array<DOMTimeLine>, scene:Scene):DOMTimeLine 
    {
        for (line in lines) {
            if (line.name == scene.name) return line;
        }
        return null;
    }

    public function addMvTimeLine(mv:MovieClip, timelines:Array<DOMTimeLine>):Void 
    {
        this.mvTimelines.set(mv, timelines);
    }

    public function removeMvTimeLine(mv:MovieClip):Void 
    {
        this.mvTimelines.remove(mv);
    }

    public function getTimelines(mv:MovieClip):Array<DOMTimeLine> 
    {
        return mvTimelines.get(mv);
    }

    public function getScenes(mv:MovieClip):Array<Scene>
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