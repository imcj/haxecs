package hx.xfl.assembler;

class DOMLayerAssembler extends XFLBaseAssembler
{
    static var _instance:DOMLayerAssembler;
    static public var instance(get, null):DOMLayerAssembler;

    var frameAssembler:DOMFrameAssembler;

    public function new()
    {
        super();

        frameAssembler = DOMFrameAssembler.instance;
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

    static function get_instance():DOMLayerAssembler
    {
        if (null == _instance)
            _instance = new DOMLayerAssembler();

        return _instance;
    }
}