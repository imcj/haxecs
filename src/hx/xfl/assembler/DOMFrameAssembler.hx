package hx.xfl.assembler;

class DOMFrameAssembler extends XFLBaseAssembler
{
    static var _instance:DOMFrameAssembler;
    static public var instance(get, null):DOMFrameAssembler;

    var assemblers:Map<String, IDOMElementAssembler>;

    public function new()
    {
        super();
        assemblers = new Map();
        assemblers.set("DOMSymbolInstance", new DOMSymbolInstanceAssembler());
        assemblers.set("DOMBitmapInstance", new DOMBitmapInstanceAssembler());
    }

    public function parse(data:Xml):Array<DOMFrame>
    {
        var frames = [];
        var frame;
        for (element in data.elements()) {
            frame = new DOMFrame();
            fillProperty(frame, element);
            frames.push(frame);

            for (dom_element in element.firstElement().elements()) {
                frame.addElement(
                    assemblers.get(dom_element.nodeName).parse(dom_element));
            }
        }

        return frames;
    }

    static function get_instance():DOMFrameAssembler
    {
        if (null == _instance)
            _instance = new DOMFrameAssembler();

        return _instance;
    }
}