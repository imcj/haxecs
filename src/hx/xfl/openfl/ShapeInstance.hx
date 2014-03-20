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

        // 绘制线条
        for (edge in dom.edges) {
            var stroke = dom.strokes.get(edge.strokeStyle);
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
        }

        //绘制填充
        var prefill = null;
        for (edge in dom.fillEdges) {
            var fill = dom.fills.get(edge.fillStyle1);
            if(edge.fillStyle0 !=0)fill = dom.fills.get(edge.fillStyle0);
            if (null != fill) {
                switch (fill.type) {
                    case "SolidColor":
                        if (fill != prefill) {
                            this.graphics.beginFill(fill.color);
                        }
                        prefill = fill;
                }
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
                trace(draw.x , draw.y);
            }
        }
    }
    
}