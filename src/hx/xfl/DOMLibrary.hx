package hx.xfl;

class DOMLibrary
{
    public var items:Array<DOMItem>;

    public function new()
    {
        items = [];
    }

    public function findItemIndex(namePath:String):Int
    {
        for (i in 0...items.length)
            if (namePath == items[i].name)
                return i;

        return -1;
    }
}