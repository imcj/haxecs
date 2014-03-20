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
        var prefill = null;
        for (edge in dom.edges) {
            var fill = dom.fills.get(edge.fillStyle1);
            var stroke = dom.strokes.get(edge.strokeStyle);
            if (null != fill) {
                switch (fill.type) {
                    case "SolidColor":
                        if (fill != prefill) {
                            this.graphics.beginFill(fill.color);
                        }
                        prefill = fill;
                }
            }
            if (null != stroke) {
                switch (stroke.type) {
                    case "SolidStroke":
                        this.graphics.lineStyle(stroke.weight, stroke.color);
                }
            }else {
                this.graphics.lineStyle();
            }
            for (draw in edge.edges) {
                switch (draw.type) {
                    case "moveTo":
                        this.graphics.moveTo(draw.x, draw.y);
                    case "lineTo":
                        this.graphics.lineTo(draw.x, draw.y);
                    case "curveTo":
                        this.graphics.curveTo(draw.x, draw.y, draw.anchorX, draw.anchorY);
                }
            }
            //this.graphics.endFill();
        }
        
    }
    
}