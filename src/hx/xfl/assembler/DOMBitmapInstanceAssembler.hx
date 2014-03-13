package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;

class DOMBitmapInstanceAssembler extends DOMElementAssembler
                                 implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    // override public function parse(data:Xml):DOMBitmapInstance
    // {
    //     var element = super.parse(data);

    //     for (element in data.elements()) {
    //     }

    //     return cast(element, DOMBitmapInstance);
    // }

    override public function createElement():IDOMElement
    {
        return new DOMBitmapInstance();
    }
}