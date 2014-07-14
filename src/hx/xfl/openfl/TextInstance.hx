package hx.xfl.openfl;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.FontType;
import flash.text.TextFormatAlign;
import flash.geom.Matrix;
import hx.xfl.assembler.DOMTimeLineAssembler;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;
import hx.xfl.DOMTimeLine;
import hx.xfl.DOMText;
import hx.xfl.XFLDocument;
import hx.xfl.openfl.display.IElement;
import hx.xfl.openfl.FontManager;

using logging.Tools;

class TextInstance extends TextField implements IElement
{
    var fontManager:FontManager;

    public function new(dom:DOMText) 
    {
        super();
        fontManager = FontManager.shared;
        render(dom);
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

    public function render(dom:DOMText):Void
    {
        // TODO
        // * 格式的完整支持
        // * 嵌入字体的支持
        // * 粗体 Helvetica-Bold
        var attr = dom.getTextRunAt(0).textAttrs;
        var alignment = alignmentEnumToString(attr.alignment);
        #if flash
        var font = fontManager.get("assets/font/" + attr.face);
        #else
        var font = fontManager.get("assets/font/" + attr.face + ".ttf");
        #end
        if (font == null) font = fontManager.get(attr.face);
        
        var font_name:String = "";
        if (null == font) {
            error('not font ${attr.face}');
        } else
            font_name = font.fontName;

        embedFonts = font.fontType != DEVICE;
        defaultTextFormat = new TextFormat(font_name, attr.size, attr.fillColor,
            attr.bold, attr.italic, null/* underline*/, attr.url, attr.target,
            alignment);

        text   = dom.getTextRunAt(0).characters;
        width  = dom.width;
        height = dom.height;
        height += 5;

        //处理文本域类型
        switch (dom.type) {
            case "DOMInputText":
                type = INPUT;
            default:
                type = DYNAMIC;
                selectable = false;
        }

        var matrix = dom.matrix.toFlashMatrix();
        matrix.ty -= 6;
        this.transform.matrix = matrix;
    }
}