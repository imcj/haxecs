package hx.xfl.assembler;

import hx.xfl.assembler.XFLBaseAssembler;

class DOMAnimationCoreAssembler extends XFLBaseAssembler
{

    public function new(document)
    {
        super(document);
    }

    public function parse(data:Xml):DOMAnimationCore
    {
        var animation = new DOMAnimationCore();
        return animation;
    }
}