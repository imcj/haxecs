package hx.xfl.assembler;

import hx.geom.Matrix;

class DOMSymbolInstanceAssembler extends DOMElementAssembler
                                 implements IDOMElementAssembler
{
    public function new()
    {
        super();
    }

    // public function parse(data:Xml):IDOMElement
    // {
    //     return super.parse(data);
    // }

    override function createElement():IDOMElement
    {
        return new DOMSymbolInstance();
    }
}