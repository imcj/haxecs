package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;

class DOMBitmapInstanceAssembler extends DOMInstanceAssembler
                                 implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    override public function parse(data:Xml):DOMBitmapInstance
    {
        var element = cast(super.parse(data), DOMBitmapInstance);

        if (data.exists("libraryItemName")) {
            var library_item_name = data.get("libraryItemName");
            element.libraryItem = document.getMedia(library_item_name);
        }

        return element;
    }

    override public function createElement():IDOMElement
    {
        return new DOMBitmapInstance();
    }
}