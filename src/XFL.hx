package ;

import flash.Lib;
import hx.xfl.openfl.display.FPS;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.MovieClipFactory;
import hx.xfl.XFLDocument;

class XFL extends MovieClip
{
    /**
     * xfl对象，生成解析好的场景
     * @param path xfl文件所在路径，不包含*.xfl
     */
    public function new(path:String) 
    {
        super();
        var d = XFLDocument.open(path);
        MovieClipFactory.dispatchTimeline(this, d.timeLines);
    }
    
    /**
     * 加载xfl文件
     * @param path xfl文件所在路径，不包含*.xfl
     * @return XFL实例
     */
    static public function load(path:String):MovieClip 
    {
        return new XFL(path);
    }
    
    static public function showInfo():Void 
    {
        var fps = new FPS();
        Lib.current.stage.addChild(fps);
    }
}