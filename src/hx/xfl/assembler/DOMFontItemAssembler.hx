package ;

import hx.xfl.assembler.XFLBaseAssembler;

class DOMFontItemAssembler extends XFLBaseAssembler
{

    public function new(document) {
        super(document);
    }

    public function parse(data:Xml):DOMFontItem 
    {
        var fontItem = new DOMFontItem;
        fillProperty(fontItem, data, ["sourceLastImported"]);

        
        return fontItem;
    }
}