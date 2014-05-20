package ;

import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.MovieClipFactory;
import hx.xfl.XFLDocument;

class XFL extends MovieClip
{

    public function new(path:String) 
    {
        super();
        var d = XFLDocument.open(path);
        MovieClipFactory.dispatchTimeline(this, d.timeLines);
    }
    
    static public function load(path:String):MovieClip 
    {
        return new XFL(path);
    }
}