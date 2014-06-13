package hx.xfl;

class DOMText extends DOMElement
{
    public var accName:String;
    public var antiAliasSharpness:Float;
    public var antiAliasThickness:Float;
    public var autoExpand:Bool;
    public var border:Bool;
    public var description:String;
    public var embeddedCharacters:String;
    public var embedRanges:String;
    public var embedVariantGlyphs:Bool;
    public var fontRenderingMode:String;
    public var length:Int;
    public var lineType:String;
    public var maxCharacters:Int;
    public var orientation:String;
    public var renderAsHTML:Bool;
    public var scrollable:Bool;
    public var selectable:Bool;
    public var selectionEnd:Int;
    public var selectionStart:Int;
    public var shortcut:String;
    public var silent:Bool;
    public var tabIndex:Int;
    public var isSelectable:Bool;
    public var textAttrs:DOMTextAttrs;
    public var useDeviceFonts:Bool;
    public var variableName:String;
    public var type:String;
    public var hasAccessibleData:Bool;

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