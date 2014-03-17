package hx.xfl.assembler;

import hx.xfl.DOMShape;

class DOMShapeAssembler extends DOMElementAssembler
                        implements IDOMElementAssembler
{

    public function new(document)
    {
        super(document);
    }
    
    override public function parse(data:Xml):IDOMElement {
        var instance = cast(super.parse(data), DOMShape);
        if (data.exists("libraryItemName")) {
            var i = document.library.findItemIndex(data.get("libraryItemName"));
            instance.libraryItem = cast(document.library.items[i],
                DOMSymbolItem);
        }

        // TODO
        // 解析矢量图绘制数据
        return instance;
    }

    override public function createElement():IDOMElement {
        return new DOMShape();
    }
}