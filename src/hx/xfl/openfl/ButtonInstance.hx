package hx.xfl.openfl;

import flash.display.SimpleButton;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;

class ButtonInstance extends SimpleButton
{
    public var dom:DOMSymbolInstance;

    public function new(dom:DOMSymbolInstance) 
    {
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMSymbolItem = 
        cast(document.getSymbol(dom.libraryItem.name), DOMSymbolItem);

        var upState = new Sprite();
        var overState = new Sprite();
        var downState = new Sprite();
        for (dom in file.timeline.layers) {
            var layer = new Layer(dom);
            layer.gotoAndStop(0);
            upState.addChild(layer);

            var layer = new Layer(dom);
            layer.gotoAndStop(1);
            overState.addChild(layer);

            var layer = new Layer(dom);
            layer.gotoAndStop(2);
            downState.addChild(layer);
        }

        super(upState, overState, downState, upState);
        this.transform.matrix = dom.matrix.toFlashMatrix();
    }
}