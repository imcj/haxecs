package hx.xfl;

class DOMSymbolItem extends DOMItem
{
    public var itemID:String;
    public var symbolType:String;
    public var timelines:Array<DOMTimeLine>;

    public function new() 
    {
        itemID = null;
        symbolType = "movie clip";
        timelines = [];

        super();
    }

}