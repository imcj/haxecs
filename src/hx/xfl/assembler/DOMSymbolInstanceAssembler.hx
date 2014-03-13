package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMSymbolInstance;

class DOMSymbolInstanceAssembler extends DOMElementAssembler
                                 implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    override public function parse(data:Xml):IDOMElement
    {
        var instance = cast(super.parse(data), DOMSymbolInstance);
        var i = document.library.findItemIndex(data.get("libraryItemName"));
        instance.libraryItem = cast(document.library.items[i], DOMSymbolItem);

        return instance;
    }

    override function createElement():IDOMElement
    {
        return new DOMSymbolInstance();
    }
}