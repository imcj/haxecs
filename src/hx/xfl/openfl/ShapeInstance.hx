package hx.xfl.openfl;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import hx.xfl.DOMShape;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;

class ShapeInstance
{
    var dom:DOMShape;
    var target:Sprite;

    public function new(dom:DOMShape, target:Sprite)
    {
        this.dom = dom;
        this.target = target;
        var document = dom.frame.layer.timeLine.document;

        //绘制填充
        for (edge in dom.fillEdges1) {
            var fill = dom.fills.get(edge.fillStyle1);
            if (null != fill) {
                switch (fill.type) {
                    case "SolidColor":
                        target.graphics.beginFill(fill.color, fill.alpha);
                    case "RadialGradient":
                        target.graphics.beginGradientFill(GradientType.RADIAL, cast(fill.colors), fill.alphas, fill.ratios, fill.matrix.toFlashMatrix(), fill.spreadMethod, fill.interpolationMethod, fill.focalPointRatio);
                    case "LinearGradient":
                        target.graphics.beginGradientFill(GradientType.LINEAR, cast(fill.colors), fill.alphas, fill.ratios, fill.matrix.toFlashMatrix(), fill.spreadMethod, fill.interpolationMethod, fill.focalPointRatio);
                    case "BitmapFill":
                        target.graphics.beginBitmapFill(fill.bitmapData, fill.matrix.toFlashMatrix());
                }
            }
            for (draw in edge.edges) {
                switch (draw.type) {
                    case "moveTo":
                        target.graphics.moveTo(draw.x, draw.y);
                    case "lineTo":
                        target.graphics.lineTo(draw.x, draw.y);
                    case "curveTo":
                        target.graphics.curveTo(draw.x, draw.y, draw.anchorX, draw.anchorY);
                }
            }
            target.graphics.endFill();
        }

        // 绘制线条
        for (edge in dom.edges) {
            var stroke = dom.strokes.get(edge.strokeStyle);
            if (null != stroke) {
                switch (stroke.type) {
                    case "SolidStroke":
                        target.graphics.lineStyle(stroke.weight, stroke.color);
                }
            }else {
                target.graphics.lineStyle();
            }
            for (draw in edge.edges) {
                switch (draw.type) {
                    case "moveTo":
                        target.graphics.moveTo(draw.x, draw.y);
                    case "lineTo":
                        target.graphics.lineTo(draw.x, draw.y);
                    case "curveTo":
                        target.graphics.curveTo(draw.x, draw.y, draw.anchorX, draw.anchorY);
                }
            }
        }
    }
    
}