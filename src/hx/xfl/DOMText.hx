package hx.xfl;

class DOMText extends DOMElement
{
    public var autoExpand:Bool;
    public var isSelectable:Bool;
    public var textAttrs:DOMTextAttrs;

    var _textRuns:Array<DOMTextRun>;
    
    public function new()
    {
        super();

        _textRuns = [];
        isSelectable = true;
    }

    public function addTextRun(textRun)
    {
        _textRuns.push(textRun);
    }

    public function getTextRunAt(index:Int):DOMTextRun
    {
        return _textRuns[index];
    }
}