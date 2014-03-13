package hx.xfl;

/**
 * ...
 * @author Sunshine
 */
class DOMSymbolItem extends DOMItem
{
    public var itemID:String;
    public var symbolType:String;
    public var timeline:DOMTimeLine;

    public function new() 
    {
        itemID = null;
        symbolType = "movie clip";
        timeline = null;

        super();
    }

}