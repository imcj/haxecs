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

            var last:DOMFrame;
            var frames = frameAssembler.parse(element.firstElement());
            last = frames[frames.length - 1];
            for (frame in frames) {
                layer.addFrame(frame);
            }

            if (null != last)
                layer.totalFrames = last.index + last.duration;

            if (frames.length == 1 && last.index == 0 && last.duration == 0)
                layer.totalFrames = 1;
        }

        return layers;
    }
}