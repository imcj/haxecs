package ;

import flash.text.Font;
import hx.xfl.assembler.XFLBaseAssembler;
import openfl.Assets;

class DOMFontItemAssembler extends XFLBaseAssembler
{

    public function new(document) {
        super(document);
    }

    public function parse(data:Xml):DOMFontItem 
    {
        var fontItem = new DOMFontItem;
        fillProperty(fontItem, data, ["sourceLastImported"]);

        fontItem.font = Assets.getFont("assets/font/" + fontItem.name.toUpperCase() + ".TTF");
        return fontItem;
    }
}