package hx.xfl.openfl;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.Matrix;
import hx.xfl.assembler.DOMTimeLineAssembler;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;
import hx.xfl.DOMTimeLine;
import hx.xfl.DOMText;
import hx.xfl.XFLDocument;
import flash.text.TextFormatAlign;

class TextInstance extends TextField
{
    public var dom:DOMText;

    public function new(dom:DOMText) 
    {
        super();
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;

        // TODO
        // * 格式的完整支持
        // * 嵌入字体的支持
        var attr = dom.getTextRunAt(0).textAttrs;
        var alignment = alignmentEnumToString(attr.alignment);
        defaultTextFormat = new TextFormat(attr.face, attr.size, attr.fillColor,
            attr.bold, attr.italic, null/* underline*/, attr.url, attr.target,
            alignment);
            // attr.align, attr.)

        text   = dom.getTextRunAt(0).characters;
        width  = dom.width;
        height = dom.height + 10;
        selectable = dom.isSelectable;

        //处理文本域类型
        type = switch (dom.type) {
            case "DOMInputText":
                "INPUT";
            default:
                "DYNAMIC";
        }

        var matrix = dom.matrix.toFlashMatrix();
        matrix.ty -= 6;
        this.transform.matrix = matrix;

        this.x += dom.left;
        this.y += dom.top;
    }

    function alignmentEnumToString(alignment)
    {
        switch (alignment) {
            case "center":
                return TextFormatAlign.CENTER;
            case "justify":
                return TextFormatAlign.JUSTIFY;
            case "left":
                return TextFormatAlign.LEFT;
            case "right":
                return TextFormatAlign.RIGHT;
        }

        return null;
    }
}