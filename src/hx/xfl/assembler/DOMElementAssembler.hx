package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;

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
}