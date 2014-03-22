package hx.xfl.openfl;

import flash.display.Shape;
import flash.Lib;
import flash.text.TextField;
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

        //绘制填充
        for (edge in dom.fillEdges0) {
            var fill = dom.fills.get(edge.fillStyle0);
            if (null != fill) {
                switch (fill.type) {
                    case "SolidColor":
                        this.graphics.beginFill(fill.color,fill.alpha);
                        #if debug trace("Fill0",edge.fillStyle0);#end
                }
            }
            var n = 0;
            for (draw in edge.edges) {
                switch (draw.type) {
                    case "moveTo":
                        if (n != 0) this.graphics.lineTo(draw.x, draw.y);
                        else this.graphics.moveTo(draw.x, draw.y);
                    case "lineTo":
                        this.graphics.lineTo(draw.x, draw.y);
                    case "curveTo":
                        this.graphics.curveTo(draw.x, draw.y, draw.anchorX, draw.anchorY);
                }
                #if debug
                trace(draw.type, draw.x, draw.y);
                var text = new TextField();
                text.x = draw.x;
                text.y = draw.y;
                text.text = draw.x + "," + draw.y;
                Lib.current.stage.addChild(text);
                #end
                n++;
            }
            this.graphics.endFill();
        }
        for (edge in dom.fillEdges1) {
            var fill = dom.fills.get(edge.fillStyle1);
            if (null != fill) {
                switch (fill.type) {
                    case "SolidColor":
                        this.graphics.beginFill(fill.color, fill.alpha);
                        #if debug trace("Fill1",edge.fillStyle1); #end
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
                #if debug
                trace(draw.type, draw.x, draw.y);
                var text = new TextField();
                text.x = draw.x;
                text.y = draw.y;
                text.text = draw.x + "," + draw.y;
                Lib.current.stage.addChild(text);
                #end
            }
            this.graphics.endFill();
        }

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
    }
    
}