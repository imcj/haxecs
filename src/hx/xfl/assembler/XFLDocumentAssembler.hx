package hx.xfl.assembler;

import hx.xfl.XFLDocument;
import hx.xfl.DOMFolderItem;

using logging.Tools;

class XFLDocumentAssembler extends XFLBaseAssembler
{
    public var assemblerTimeLine:DOMTimeLineAssembler;

    var cached:Map<String, String>;

    public function new()
    {
        super(new XFLDocument());
        assemblerTimeLine = new DOMTimeLineAssembler(document);
        cached = new Map();
    }

    #if neko
    function read(file:String, ?cache:Bool=false)
    {
        var content:String;
        if (cache) {
            content = cached.get(file);
            if (null != content)
                return content;
        }

        content = sys.io.File.getContent(file);
        if (cache)
            cached.set(file, content);
        return content;
    }
    #end

    function parseFolders(data:Xml):Array<DOMFolderItem>
    {
        var folders:Array<DOMFolderItem> = [];
        for (element in data.elements()) {

        }

        return folders;
    }

    function parseMedia(document, data:Xml):Void
    {
        var libraryItem:DOMItem = null;

        for (element in data.elements()) {
            if ("DOMBitmapItem" == element.nodeName)
                libraryItem = new DOMBitmapItem();
            else if ("DOMSoundItem" == element.nodeName)
                libraryItem = new DOMSoundItem();
            else
                throw "未知的类型";

            fillProperty(libraryItem, element);
            document.addMedia(libraryItem);
        }
    }

    function parseSymbol(document:XFLDocument, data:Xml):Void 
    {
        var symbolItem;
        var xml:Map<String, Xml> = new Map();

        for (element in data.elements()) {
            var symbolItem = new DOMSymbolItem();
            var file = document.dir + "/LIBRARY/" + element.get("href");
            var text:String;
            #if cstool
            text = read(file, true);
            #else
            text = document.assets.getText(file);
            #end

            if (null == text || "" == text)
                throw '$file is empty.';
            var symbolXml = Xml.parse(text).firstChild();
            symbolItem.name = symbolXml.get("name");

            xml.set(symbolItem.name, symbolXml);

            fillProperty(symbolItem, symbolXml, ["lastUniqueIdentifier"]);
            document.library.items.push(symbolItem);
            document.addSymbol(symbolItem);
        }

        for (element in data.elements()) {
            var symbol_item_name = element.get("href").substr(0, -4);
            symbolItem = document.getSymbol(symbol_item_name);
            var file = document.dir + "/LIBRARY/" + element.get("href");
            var text:String;
            #if cstool
            text = read(file, true);
            #else
            text = document.assets.getText(file);
            #end
            var symbolXml = Xml.parse(text).firstChild();


            fillProperty(symbolItem, symbolXml, ["lastUniqueIdentifier"]);
            var symbolIndex = document.library.findItemIndex(symbolItem.name);
            symbolItem = cast(document.library.items[symbolIndex]);

            for (timeline in symbolXml.elements()) {
                if ("timeline" == timeline.nodeName) {
                    symbolItem.timeline = assemblerTimeLine.parse(timeline)[0];
                    symbolItem.timeline.document = document;
                }/* else if ("include" == timeline.nodeName.toLowerCase()) {

                }*/
            }
        }
    }

    public function parseFont(document:XFLDocument, data:Xml):Void 
    {
        var fontItem = new DOMFontItem();
        fillProperty(fontItem, data, ["sourceLastImported"]);

        /**
         * FIXME 更好的字体支持
         *
        var font = document.assets.getFont("assets/font/" + fontItem.font +
            ".ttf");
        if (font != null)fontItem.fontName = font.fontName;
        else throw("字体文件" + fontItem.font.toUpperCase() + 
            ".TTF缺失，请拷贝字体到asstes/font文件夹下");
        */
        document.addFont(fontItem);
    }

    public function parse(data:Xml, path:String):XFLDocument
    {
        debug('开始分析XML文件 DOMDocument.xml.');
        fillProperty(document, data.firstChild());
        document.dir = path;

        for (element in data.firstChild().elements()) {
            if ("folders" == element.nodeName) {
                parseFolders(element);
            } else if ("media" == element.nodeName) {
                parseMedia(document, element);
            } else if ("symbols" == element.nodeName) {
                parseSymbol(document, element);
            } else if ("timelines" == element.nodeName) {
                for (timeLine in assemblerTimeLine.parse(element))
                    document.addTimeLine(timeLine);
            } else if ("PrinterSettings" == element.nodeName) {

            } else if ("publishHistory" == element.nodeName) {

            } else if ("fonts" == element.nodeName) {
                for (e in element.elements())
                    parseFont(document, e);
            }
        }

        return document;
    }
}