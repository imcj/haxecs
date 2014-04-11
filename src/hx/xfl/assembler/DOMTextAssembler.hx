package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMText;

using StringTools;

class DOMTextAssembler extends DOMElementAssembler
                       implements IDOMElementAssembler
{
    public function new(document)
    {
        super(document);
    }

    override public function parse(data:Xml):IDOMElement
    {
        var element = cast(super.parse(data), DOMText);
        element.type = data.nodeName;
        // text children
        var text = cast(element, DOMText);
        for (node in data.elements()) {
            if ("textRuns" == node.nodeName) {
                for (textRunsNode in node.elements())
                    text.addTextRun(parseTextRun(textRunsNode));
            }
        }

        return element;
    }

    override function createElement():IDOMElement
    {
        return new DOMText();
    }

    function parseTextRun(node:Xml):DOMTextRun
    {
        var textRun:DOMTextRun;
        // var textRuns:Array<DOMTextRun> = [];
        textRun = new DOMTextRun();
        for (item in node.elements()) {
            if ("characters" == item.nodeName) {
                if (null == item)
                    continue;
                textRun.characters = item.firstChild() == null?"":item.firstChild().nodeValue;
            } else if ("textAttrs" == item.nodeName) {
                textRun.textAttrs = parseTextAttrs(item.firstElement());
            }
        }
        return textRun;
    }

    function parseTextAttrs(node:Xml):DOMTextAttrs
    {
        var attrs = new DOMTextAttrs();
        var fillColor:String;
        fillColor = node.get("fillColor");
        fillProperty(attrs, node, ["fillColor"]);
        if (null != fillColor)
            attrs.fillColor = Std.parseInt(fillColor.replace("#", "0x"));

        return attrs;
    }
}