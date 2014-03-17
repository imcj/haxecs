package hx.xfl.openfl;

import flash.display.Shape;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;

class ShapeInstance extends Shape
{
    var dom:DOMSymbolInstance;

    public function new(dom:DOMSymbolInstance)
    {
        super();
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMSymbolItem = 
        cast(document.getSymbol(dom.libraryItem.name), DOMSymbolItem);

        // TODO
        // 实现矢量图绘制，目前只是用个红色圆代替
        this.graphics.beginFill(0xff0000);
        this.graphics.drawCircle(0, 0, 50);
    }
    
}