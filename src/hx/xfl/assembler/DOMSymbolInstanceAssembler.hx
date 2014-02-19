package hx.xfl.assembler;

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

        return symbolInstance;
    }
}