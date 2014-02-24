package hx.xfl.openfl;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Matrix;
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

    public function new(dom:DOMSymbolInstance) 
    {
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMSymbolItem = 
        cast(document.getSymbol(dom.libraryItemName), DOMSymbolItem);

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

        this.transform.matrix = dom.matrix.toFlashMatrix();
        
        super(upState, overState, downState, upState);
    }
}