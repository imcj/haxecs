package hx.xfl.assembler;

import hx.xfl.filter.BlurFilter;
import hx.xfl.filter.ColorMatrixFilter;
import hx.xfl.filter.DropShadowFilter;
import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;
import hx.xfl.filter.Filter;
import hx.xfl.filter.GlowFilter;

class DOMElementAssembler extends XFLBaseAssembler
                          implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    public function parse(data:Xml):IDOMElement
    {
        var element:IDOMElement = createElement();
        fillProperty(element, data, ["libraryItemName"]);

        for (elementNode in data.elements()) {
            parse_matrix(elementNode, element);
            parse_transformPoint(elementNode, element);
            parse_colorTransform(elementNode, element);
            parse_filters(elementNode, element);
        }

        return element;
    }

    public function createElement():IDOMElement
    {
        throw "Not implements";
        return null;
    }

    inline function parse_matrix(elementNode:Xml, element)
    {
        var matrix = element.matrix;
        var matrix_a:String, matrix_b:String, matrix_c:String, matrix_d:String,
            matrix_tx:String, matrix_ty:String;

        if ("matrix" == elementNode.nodeName) {
            matrix_a  = elementNode.firstElement().get('a');
            matrix_b  = elementNode.firstElement().get('b');
            matrix_c  = elementNode.firstElement().get('c');
            matrix_d  = elementNode.firstElement().get('d');
            matrix_tx = elementNode.firstElement().get('tx');
            matrix_ty = elementNode.firstElement().get('ty');

            if (null != matrix_a)
                matrix.a = Std.parseFloat(matrix_a);

            if (null != matrix_b)
                matrix.b = Std.parseFloat(matrix_b);

            if (null != matrix_c)
                matrix.c = Std.parseFloat(matrix_c);

            if (null != matrix_d)
                matrix.d = Std.parseFloat(matrix_d);

            if (null != matrix_tx)
                matrix.tx = Std.parseFloat(matrix_tx);

            if (null != matrix_ty)
                matrix.ty = Std.parseFloat(matrix_ty);

        }
    }

    function parse_transformPoint(elementNode:Xml, element):Void 
    {
        var transformPoint = element.transformPoint;
        var transformPoint_x:String, transformPoint_y:String;

        if ("transformationPoint" == elementNode.nodeName) {
            transformPoint_x = elementNode.firstElement().get('x');
            transformPoint_y = elementNode.firstElement().get('y');

            if (null != transformPoint_x) {
                transformPoint.x = Std.parseFloat(transformPoint_x);
            }

            if (null != transformPoint_y) {
                transformPoint.y = Std.parseFloat(transformPoint_y);
            }
        }
    }

    function parse_colorTransform(elementNode:Xml, element):Void 
    {
        var colorTransform = element.colorTransform;
        var alphaMultiplier:String, alphaOffset:String,
            blueMultiplier:String, blueOffset:String,
            color:String,
            greenMultiplier:String, greenOffset:String,
            redMultiplier:String, redOffset:String,
            brightness:String,
            tintMultiplier:String, tintColor:String;

        if ("color" == elementNode.nodeName) {
            alphaMultiplier = elementNode.firstElement().get('alphaMultiplier');
            alphaOffset = elementNode.firstElement().get('alphaOffset');
            blueMultiplier = elementNode.firstElement().get('blueMultiplier');
            blueOffset = elementNode.firstElement().get('blueOffset');
            color = elementNode.firstElement().get('color');
            greenMultiplier = elementNode.firstElement().get('greenMultiplier');
            greenOffset = elementNode.firstElement().get('greenOffset');
            redMultiplier = elementNode.firstElement().get('redMultiplier');
            redOffset = elementNode.firstElement().get('redOffset');
            brightness = elementNode.firstElement().get('brightness');
            tintMultiplier = elementNode.firstElement().get('tintMultiplier');
            tintColor = elementNode.firstElement().get('tintColor');

            if (null != alphaMultiplier) {
                colorTransform.alphaMultiplier = Std.parseFloat(alphaMultiplier);
            }

            if (null != alphaOffset) {
                colorTransform.alphaOffset = Std.parseFloat(alphaOffset);
            }
            
            if (null != blueMultiplier) {
                colorTransform.blueMultiplier = Std.parseFloat(blueMultiplier);
            }
            
            if (null != blueOffset) {
                colorTransform.blueOffset = Std.parseFloat(blueOffset);
            }
            
            if (null != color) {
                colorTransform.color = Std.parseInt("0x"+color.substr(1));
            }
            
            if (null != greenMultiplier) {
                colorTransform.greenMultiplier = Std.parseFloat(greenMultiplier);
            }
            
            if (null != greenOffset) {
                colorTransform.greenOffset = Std.parseFloat(greenOffset);
            }
            
            if (null != redMultiplier) {
                colorTransform.redMultiplier = Std.parseFloat(redMultiplier);
            }
            
            if (null != redOffset) {
                colorTransform.redOffset = Std.parseFloat(redOffset);
            }
            
            if (null != brightness) {
                var b = Std.parseFloat(brightness);
                if (b > 0) {
                    colorTransform.redOffset = b * 255;
                    colorTransform.greenOffset = b * 255;
                    colorTransform.blueOffset = b * 255;
                }
                b = Math.abs(b);
                colorTransform.redMultiplier = 1 - b;
                colorTransform.greenMultiplier = 1 - b;
                colorTransform.blueMultiplier = 1 - b;
            }
            
            if (null != tintMultiplier) {
                var tint = Std.parseFloat(tintMultiplier);
                var c = Std.parseInt("0x"+tintColor.substr(1));
                var r = c >> 16;
                var g = c >> 8 & 0xFF;
                var b = c & 0xFF;
                colorTransform.redOffset = tint * r;
                colorTransform.greenOffset = tint * g;
                colorTransform.blueOffset = tint * b;
                colorTransform.redMultiplier = 1 - tint;
                colorTransform.greenMultiplier = 1 - tint;
                colorTransform.blueMultiplier = 1 - tint;
            }
        }
    }
    
    function parse_filters(elementNode:Xml, element):Void
    {
        var filters = element.filters;
        for (e in elementNode.elements()) {
            var f:Filter = null;
            if (e.nodeName == "DropShadowFilter") f = new DropShadowFilter();
            if (e.nodeName == "BlurFilter") f = new BlurFilter();
            if (e.nodeName == "GlowFilter") f = new GlowFilter();
            if (e.nodeName == "AdjustColorFilter") f = new ColorMatrixFilter();
            if (f != null) {
                f.parse(e);
                filters.push(f);
            }
        }
    }
}