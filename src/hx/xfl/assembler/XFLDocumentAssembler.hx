package hx.xfl.assembler;

import hx.xfl.XFLDocument;
import hx.xfl.DOMFolderItem;

class XFLDocumentAssembler extends XFLBaseAssembler
{
    public var assemblerTimeLine:DOMTimeLineAssembler;

    public function new()
    {
        super(new XFLDocument());
        assemblerTimeLine = new DOMTimeLineAssembler(document);
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

        //先记录全部Include
        for (element in data.elements()) {
            var symbolItem = new DOMSymbolItem();
            var file = document.dir + "/LIBRARY/" + element.get("href");
            var text = hx.xfl.openfl.Assets.getText(file);
            var symbolXml = Xml.parse(text).firstChild();

            fillProperty(symbolItem, symbolXml);
            document.library.items.push(symbolItem);
            document.addSymbol(symbolItem);
        }

        for (element in data.elements()) {
            var symbolItem = new DOMSymbolItem();
            var file = document.dir + "/LIBRARY/" + element.get("href");
            var text = hx.xfl.openfl.Assets.getText(file);
            var symbolXml = Xml.parse(text).firstChild();

            fillProperty(symbolItem, symbolXml);
            var symbolIndex = document.library.findItemIndex(symbolItem.name);
            symbolItem = cast(document.library.items[symbolIndex]);

            for (timeline in symbolXml.elements()) {
                if ("timeline" == timeline.nodeName) {
                    symbolItem.timelines = assemblerTimeLine.parse(timeline);
                    for (tl in symbolItem.timelines) {
                        tl.document = document;
                    }
                }/* else if ("include" == timeline.nodeName.toLowerCase()) {

                }*/
            }
        }
    }

    public function parse(data:Xml, path:String):XFLDocument
    {
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
}