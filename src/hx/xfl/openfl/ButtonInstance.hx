package hx.xfl.openfl;

import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import hx.xfl.assembler.DOMTimeLineAssembler;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;
import hx.xfl.DOMTimeLine;
import hx.xfl.XFLDocument;

/**
 * ...
 * @author Sunshine
 */
class ButtonInstance extends SimpleButton
{
    var dom:DOMSymbolInstance;
    var layers:Array<Layer>;

    public function new(dom:DOMSymbolInstance) 
    {
        layers = [];

        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMSymbolItem = 
        cast(document.getSymbol(dom.libraryItemName + ".xml"), DOMSymbolItem);

        var symbol_file = document.dir + "/LIBRARY/" + file.href;
        var text = hx.Assets.getText(symbol_file);
        var symbol_dom = Xml.parse(text).firstChild();
        var symbol_document = new XFLDocument();
        symbol_document.dir = document.dir;
        for (media in document.getMediaIterator()) {
            symbol_document.addMedia(media);
        }
        var symbol_timeline = [];
        for (element in symbol_dom.elements()) {
            if ("timeline" == element.nodeName) {
                symbol_timeline = DOMTimeLineAssembler.instance.parse(element);
            }
        }
        for (timeline in symbol_timeline) {
            symbol_document.addTimeLine(timeline);
        }
        var up = new Sprite();
        var down = new Sprite();
        var over = new Sprite();
        for (timeline in symbol_document.getTimeLinesIterator()) {
            for (dom in timeline.layers) {
                var layer = new Layer(dom);
                layer.gotoFrame(0);
                up.addChild(layer);
                var layer = new Layer(dom);
                layer.gotoFrame(1);
                over.addChild(layer);
                var layer = new Layer(dom);
                layer.gotoFrame(2);
                down.addChild(layer);
            }
        }

        this.x = dom.matrix.tx;
        this.y = dom.matrix.ty;
        
        super(up, over, down, up);
    }
}