package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMText;

using StringTools;

class DOMTextAssembler extends DOMElementAssembler
                       implements IDOMElementAssembler
{
    static var _instance:DOMTextAssembler;
    static public var instance(get, null):DOMTextAssembler;

    public function new()
    {
        super();
    }

    override public function parse(data:Xml):IDOMElement
    {
        var element = cast(super.parse(data), DOMText);
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
                textRun.characters = item.firstChild().nodeValue;
            } else if ("textAttrs" == item.nodeName) {
                textRun.textAttrs = parseTextAttrs(item.firstElement());
            }
        }
        return textRun;
    }

    function parseTextAttrs(node):DOMTextAttrs
    {
        var attrs = new DOMTextAttrs();
        fillProperty(attrs, node, ["fillColor"]);
        attrs.fillColor = Std.parseInt(
            node.get("fillColor").replace("#", "0x"));

        return attrs;
    }

    static function get_instance():DOMTextAssembler
    {
        if (null == _instance)
            _instance = new DOMTextAssembler();
        return _instance;
    }
}