package hx.xfl.assembler;

import hx.geom.Matrix;

class DOMSymbolInstanceAssembler extends XFLBaseAssembler
                                 implements IDOMElementAssembler
{
    public function new()
    {
        super();
    }

    public function parse(data:Xml):IDOMElement
    {
        var symbolInstance = new DOMSymbolInstance();
        fillProperty(symbolInstance, data);
        var matrix:Matrix = new Matrix();
        var matrix_a:String, matrix_b:String, matrix_c:String, matrix_d:String,
            matrix_tx:String, matrix_ty:String;
			
		symbolInstance.matrix = matrix;

		for (element in data.elements()) {
            if ("matrix" == element.nodeName) {
                matrix_a  = element.firstElement().get('a');
                matrix_b  = element.firstElement().get('b');
                matrix_c  = element.firstElement().get('c');
                matrix_d  = element.firstElement().get('d');
                matrix_tx = element.firstElement().get('tx');
                matrix_ty = element.firstElement().get('ty');

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
		
        return symbolInstance;
    }
}