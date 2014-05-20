package hx.xfl.openfl;

import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.display.SimpleButton;

class MovieClipFactory
{
    static public var instance(get, null):MovieClipFactory;
    static function get_instance():MovieClipFactory
    {
        if (instance == null) {
            instance = new MovieClipFactory();
        }
        return instance;
    }

    public function new()
    {
        if (instance != null) throw "MovieClipFactory是单列类";
    }

    /**
     * 根据时间轴数据生成MovieClip实例
     * @param domTimeLine 时间轴数据，可以是时间轴数组，每个时间轴作为一个场景
     * @return hx.xfl.openfl.display.MovieClip实例
     */
    static public function create(domTimeLine:Dynamic):MovieClip 
    {
        var lines = [];

        if (Reflect.hasField(domTimeLine, 'next'))
            while (domTimeLine.hasNext())
                lines.push(domTimeLine.next());
        if (Std.is(domTimeLine, Array)) lines = domTimeLine;
        else if (Std.is(domTimeLine, DOMTimeLine)) lines = [domTimeLine];
        else throw "domTimeLine类型错误，需要是DOMTimeLine或者Array<DOMTimeLine>";
        var mv = new MovieClip();
        addtoRenderList(mv, lines);
        return mv;
    }

    /**
     * 创建按钮
     * @param symbol 按钮元件数据
     * @return hx.xfl.openfl.display.SimpleButton
     */
    static public function createButton(symbol:DOMSymbolInstance):SimpleButton
    {
        var document  = symbol.frame.layer.timeLine.document;
        var lines = [document.getSymbol(symbol.libraryItem.name).timeline];
        var button = new SimpleButton();
        addtoRenderList(button, lines);
        return button;
    }

    /**
     * 向MovieClip实例添加时间轴数据
     * @param mv hx.xfl.openfl.display.MovieClip实例
     * @param timeline 时间轴数据
     */
    static public function dispatchTimeline(mv:MovieClip, timeline:Dynamic):Void 
    {
        var lines = [];
        if (Std.is(timeline, Array)) lines = timeline;
        if (Std.is(timeline, DOMTimeLine)) lines = [timeline];
        if (Std.is(timeline, DOMSymbolInstance)) {
            var document  = timeline.frame.layer.timeLine.document;
            lines = [document.getSymbol(timeline.libraryItem.name).timeline];
        }
        addtoRenderList(mv, lines);
    }
    
    static function addtoRenderList(mv:MovieClip, timelines:Array<DOMTimeLine>):Void 
    {
        mv.setScenes(getScenes(timelines));
        var renderer = new MovieClipRenderer(mv, timelines);
        Render.addRenderer(renderer);
    }
    
    static function getScenes(lines:Array<DOMTimeLine>):Array<Scene>
    {
        var scenes = [];
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