package hx.xfl;

class DOMText extends DOMElement
{
    public var autoExpand:Bool;
    public var isSelectable:Bool;
    public var textAttrs:DOMTextAttrs;
    public var type:String;
    public var fontRenderingMode:String;

    var _textRuns:Array<DOMTextRun>;
    
    public function new()
    {
        super();

        _textRuns = [];
        isSelectable = true;
        fontRenderingMode = "";
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