package hx.xfl.openfl;

import flash.display.Shape;
import hx.xfl.DOMShape;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;

class ShapeInstance extends Shape
{
    var dom:DOMShape;

    public function new(dom:DOMShape)
    {
        super();
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;

        // TODO
        // 实现矢量图绘制，目前只是用个红色圆代替
        var fill = dom.fills.get(dom.edge.fillStyle1);
        var stroke = dom.strokes.get(dom.edge.strokeStyle);
        switch (fill.type) {
            case "SolidColor":
                this.graphics.beginFill(fill.color);
        }
        switch (stroke.type) {
            case "SolidStroke":
                this.graphics.lineStyle(stroke.weight);
        }
        for (draw in dom.edge.edges) {
            switch (draw.type) {
                case "moveTo":
                    this.graphics.moveTo(draw.x, draw.y);
                case "lineTo":
                    this.graphics.lineTo(draw.x, draw.y);
            }
        }
        this.graphics.endFill();
    }
    
}