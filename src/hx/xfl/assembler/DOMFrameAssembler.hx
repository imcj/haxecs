package hx.xfl.assembler;

class DOMFrameAssembler extends XFLBaseAssembler
{
    var assemblers:Map<String, IDOMElementAssembler>;

    public function new(document)
    {
        super(document);
        assemblers = new Map();

        var text_assembler = new DOMTextAssembler(document);

        assemblers.set("DOMSymbolInstance",
            new DOMSymbolInstanceAssembler(document));
        assemblers.set("DOMBitmapInstance", 
            new DOMBitmapInstanceAssembler(document));
        assemblers.set("DOMShape",
            new DOMShapeAssembler(document));

        assemblers.set("DOMStaticText", text_assembler);
        assemblers.set("DOMInputText", text_assembler);
        assemblers.set("DOMDynamicText", text_assembler);
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
}