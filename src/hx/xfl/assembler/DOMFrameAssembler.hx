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
        var assembler:IDOMElementAssembler;

        for (element in data.elements()) {
            frame = new DOMFrame();
            fillProperty(frame, element);
            frames.push(frame);

            for (dom_element in element.firstElement().elements()) {
                assembler = assemblers.get(dom_element.nodeName);
                if (null == assembler)
                    continue;
                    // throw dom_element.nodeName + 
                    //       " is not support element type.";
                frame.addElement(assembler.parse(dom_element));
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