package hx.xfl.assembler;

import hx.Assets;
import hx.xfl.XFLDocument;
import hx.xfl.DOMFolderItem;

class XFLDocumentAssembler extends XFLBaseAssembler
{
    public var assemblerTimeLine:DOMTimeLineAssembler;

    static var _instance:XFLDocumentAssembler;
    static public var instance(get, null):XFLDocumentAssembler;

    public function new()
    {
        super();

        assemblerTimeLine = DOMTimeLineAssembler.instance;
    }

    function parseFolders(data:Xml):Array<DOMFolderItem>
    {
        var folders:Array<DOMFolderItem> = [];
        for (element in data.elements()) {

        }

        return folders;
    }

    function parseMedia(document, data:Xml):Void
    {
        var bitmapItem;
        for (element in data.elements()) {
            bitmapItem = new DOMBitmapItem();
            fillProperty(bitmapItem, element);
            document.addMedia(bitmapItem);
        }
    }

    function parseSymbol(document:XFLDocument, data:Xml):Void 
    {
        var symbolItem;
        for (element in data.elements()) {
            symbolItem = new DOMSymbolItem();
            var file = document.dir + "/LIBRARY/" + element.get("href");
            var text = Assets.getText(file);
            var symbolXml = Xml.parse(text).firstChild();
            fillProperty(symbolItem, symbolXml);
            for (timeline in symbolXml.elements()) {
                if ("timeline" == timeline.nodeName) {
                    symbolItem.timeline = assemblerTimeLine.parse(timeline)[0];
                    symbolItem.timeline.document = document;
                }
            }
            
            document.addSymbol(symbolItem);
        }
    }

    public function parse(data:Xml, path:String):XFLDocument
    {
        var document:XFLDocument = new XFLDocument();
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

            }
        }

        return document;
    }

    static function get_instance():XFLDocumentAssembler
    {
        if (null == _instance)
            _instance = new XFLDocumentAssembler();

        return _instance;
    }
}