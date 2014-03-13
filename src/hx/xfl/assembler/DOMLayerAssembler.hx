package hx.xfl.assembler;

class DOMLayerAssembler extends XFLBaseAssembler
{
    var frameAssembler:DOMFrameAssembler;

    public function new(document)
    {
        super(document);

        frameAssembler = new DOMFrameAssembler(document);
    }

    public function parse(data:Xml):Array<DOMLayer>
    {
        var layers = [];
        var layer;
        for (element in data.elements()) {
            layer = new DOMLayer();
            fillProperty(layer, element);
            layers.push(layer);

            for (frame in frameAssembler.parse(element.firstElement())) {
                layer.addFrame(frame);
                layer.totalFrames += frame.duration;
            }
        }

        return layers;
    }
}