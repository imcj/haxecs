package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;

class DOMInstanceAssembler extends DOMElementAssembler
                           implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    override public function parse(data:Xml):IDOMElement
    {
        return super.parse(data);
    }
}