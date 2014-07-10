package hx.xfl;

import hx.xfl.assembler.XFLDocumentAssembler;
import hx.xfl.assembler.DOMPublishSettingAssembler;
import hx.xfl.setting.publish.DOMFlashProfiles;

using StringTools;
using Lambda;

#if openfl
import flash.display.*;
import hx.xfl.openfl.Assets;
import hx.xfl.openfl.display.MovieClip;
import hx.xfl.openfl.MovieClipRenderer;
#end

class XFLDocument extends DOMDocument
{
    var mapMedia:Map<String, DOMItem>;
    var mapSymbol:Map<String, DOMSymbolItem>;
    var fonts:Map<String, DOMFontItem>;

    public var autoSaveEnabled:Bool;
    public var autoSaveHasPrompted:Bool;
    public var buildNumber:Int;
    public var backgroundColor:Int;
    public var creatorInfo:String;
    public var currentTimeline:Int;
    public var filetypeGUID:String;
    public var frameRate:Float;
    public var majorVersion:Int;
    public var minorVersion:Int;
    public var media:Array<DOMItem>;
    public var symbol:Array<DOMSymbolItem>;
    public var nextSceneIdentifier:Int;
    public var objectsSnapTo:Bool;
    public var platform:String;
    public var playOptionsPlayFrameActions:Bool;
    public var playOptionsPlayLoop:Bool;
    public var playOptionsPlayPages:Bool;
    public var tabOrderMode:String;
    public var timeLines:Array<DOMTimeLine>;
    public var timelineLabelWidth:Float;
    public var versionInfo:String;
    public var viewAngle3D:Float;
    public var width:Float;
    public var height:Float;
    public var xflVersion:Float;
    public var library:DOMLibrary;
    public var flashProfiles:DOMFlashProfiles;
    #if openfl
    public var assets:Assets;
    // public var root(get, null):MovieClip;
    var _root:MovieClip;
    #end

    public var dir:String;

    var mapTimeLines:Map<String, DOMTimeLine>;

    public function new()
    {
        super();

        autoSaveEnabled = false;
        autoSaveHasPrompted = false;
        buildNumber = 0;
        creatorInfo = "Adobe Flash Professional CS6";
        currentTimeline = 0;
        filetypeGUID = "";
        frameRate = 12;
        majorVersion = 12;
        minorVersion = 1;
        media = [];
        symbol = [];
        nextSceneIdentifier = 1;
        objectsSnapTo = false;
        platform = "Macintosh";
        playOptionsPlayFrameActions = false;
        playOptionsPlayLoop = false;
        playOptionsPlayPages = false;
        tabOrderMode = null;
        timeLines = [];
        timelineLabelWidth = 0;
        versionInfo = "Saved by Adobe Flash Macintosh 12.0 build 481";
        viewAngle3D = 0;
        xflVersion = -1;
        width = 0;
        height = 0;

        mapMedia = new Map();
        mapSymbol = new Map();
        mapTimeLines = new Map();
        fonts = new Map();

        library = new DOMLibrary();

        #if openfl
        assets = new Assets(this);
        #end
    }

    public function addMedia(libraryItem:DOMItem):XFLDocument
    {
        media.push(libraryItem);
        mapMedia.set(libraryItem.name, libraryItem);
        return this;
    }

    public function addFont(fontItem:DOMFontItem):XFLDocument 
    {
        fonts.set(fontItem.font, fontItem);
        return this;
    }

    public function getMedia(name:String):DOMItem
    {
        return mapMedia.get(name);
    }

    public function getFontName(font:String):String 
    {
        var font = fonts.get(font);
        if (font == null) return null;
        return font.font;
    }

    public function getMediaIterator():Iterator<DOMItem>
    {
        return media.iterator();
    }

    public function addSymbol(symbolItem:DOMSymbolItem):XFLDocument
    {
        symbol.push(symbolItem);
        mapSymbol.set(symbolItem.name, symbolItem);
        return this;
    }

    public function getSymbol(name:String):DOMSymbolItem
    {
        return mapSymbol.get(name);
    }

    public function getSymbolIterators():Iterator<DOMSymbolItem>
    {
        return symbol.iterator();
    }

    public function addTimeLine(timeline:DOMTimeLine):XFLDocument
    {
        timeline.document = this;
        timeLines.push(timeline);
        mapTimeLines.set(timeline.name, timeline);
        return this;
    }

    public function getTimeLineAt(i:Int):DOMTimeLine
    {
        return timeLines[i];
    }

    public function getTimeLine(name:String):DOMTimeLine
    {
        return mapTimeLines.get(name);
    }

    public function getTimeLinesIterator():Iterator<DOMTimeLine>
    {
        return timeLines.iterator();
    }

    public function forEachTimeLines(Function:DOMTimeLine->Bool):Void
    {
    }

    #if openfl
    public function get_root():MovieClip
    {
        if (null == _root) {
            // TODO
        }

        return _root;
    }

    public function root(mc:MovieClip):MovieClip
    {
        if (null != mc) {
            var timelines:Array<DOMTimeLine> = [];
            for (timeline in getTimeLinesIterator())
                timelines.push(timeline);
            new hx.xfl.openfl.MovieClipRenderer(mc, timeLines);
        }

        return mc;
    }

    public function getObject(name:String):MovieClip
    {
        var symbol = getSymbol(name);
        if (null == symbol)
            throw 'not symbol $name.';
        var linageClassAreEmpty = null == symbol.linkageClassName && "" == 
            symbol.linkageClassName;

        var mc:MovieClip = null;
        if (!linageClassAreEmpty) {
            var linkageClass = Type.resolveClass(symbol.linkageClassName);
            if (null != linkageClass)
                mc = Type.createInstance(linkageClass, []);
        }

        if (mc == null) {
            mc = new MovieClip();
        }

        // new MovieClipRenderer(mc, [cast(cast(getSymbol(name), DOMSymbolInstance).libraryItem, DOMSymbolItem).timeline]);
        new MovieClipRenderer(mc, [getSymbol(name).timeline]);

        return mc;
    }
    #end

    static public function openDirectory(path:String):XFLDocument
    {
        #if (neko || cpp)
        var xfl_file = path + "/DOMDocument.xml";
        if (!sys.FileSystem.exists(xfl_file))
            throw new hx.xfl.exception.IOError(
                'No such file or directory: \'$xfl_file\'');

        var document = new XFLDocumentAssembler().parse(
            Xml.parse(sys.io.File.getContent(xfl_file)), path);
        document.dir = path;

        return document;
        #end

        return null;
    }

    static public function openFile(path:String):XFLDocument
    {
        return null;
    }

    static public function open(path:String):XFLDocument
    {
        if (path.endsWith(".xfl")) {
            path = Path.abspath(Path.join(path, [".."]));
        }
        
        #if flash
        return openFromAsset(path);
        #end

        #if js
        return openFromAsset(path);
        #end

        #if (neko || cpp)
        /*
         * FIXME

        if (!sys.FileSystem.exists(absolute))
            throw new hx.xfl.exception.IOError(
                'No such file or directory: \'$path\'');

        if (sys.FileSystem.isDirectory(absolute)) {
            return openDirectory(path);
        } else {
            return openFile(path);
        }*/
        return openFromAsset(path);
        #end

        return null;
    }

    static public function openFromAsset(path:String):XFLDocument
    {
        #if cstool
        var document_path:String;
        document_path = Path.abspath(Path.join(path, ["DOMDocument.xml"]));
        var text = sys.io.File.getContent(document_path);
        var document = new XFLDocumentAssembler().parse(
            Xml.parse(text), path);

        if (sys.FileSystem.exists(Path.join(path, ["PublishSettings.xml"]))) {
            document.flashProfiles = new DOMPublishSettingAssembler().parse(
                Xml.parse(sys.io.File.getContent(
                    Path.join(path, ["PublishSettings.xml"]))));
        }
        #else
        var text = Asset.getText(path + "/DOMDocument.xml");
        var document = new XFLDocumentAssembler().parse(
            Xml.parse(text), path);
        document.dir = path;
        #end
        return document;
    }
}