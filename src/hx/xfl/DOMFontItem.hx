package hx.xfl;

class DOMFontItem extends DOMItem
{
    public var itemID:String;
    public var font:String;
    public var size:Int;
    public var id:Int;
    public var embeddedCharacters:String;
    public var embedRanges:String;

    public var fontName:String;

    public function new()
    {
        super();

        itemID = "";
        font = "";
        size = 0;
        id = 0;
        embeddedCharacters = "";
        embedRanges = "";
        fontName = "";
    }
    
}