package ;
import hx.xfl.DOMTimeLine;
import hx.xfl.openfl.display.MovieClip;

class MovieClipRenderer
{
    var movieClip:MovieClip;
    var timelines:Array<DOMTimeLine>;

    public function new(movieClip:MovieClip, timeline:Dynamic)
    {
        this.movieClip = movieClip;
        if (Std.is(timeline, DOMTimeLine)) this.timelines = [timeline];
        else if (Std.is(timeline, Array<DOMTimeLine>)) this.timelines = timelines;
        else throw "timeline 类型错误，需要是DOMTimeLine或者Array<DOMTimeLine>";
    }
    
    public function render():Void 
    {
        
    }
}