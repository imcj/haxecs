package hx.xfl.assembler;

class DOMTimeLineAssembler extends XFLBaseAssembler
{
    static var _instance:DOMTimeLineAssembler;
    static public var instance(get, null):DOMTimeLineAssembler;

    var layerAssembler:DOMLayerAssembler;

    public function new()
    {
        super();
        layerAssembler = DOMLayerAssembler.instance;
    }

    public function parse(data:Xml):Array<DOMTimeLine>
    {
        var timeLines = [];
        var timeLine;

        for (element in data.elements()) {
            timeLine = new DOMTimeLine();
            fillProperty(timeLine, element);
            timeLines.push(timeLine);

            for (layer in layerAssembler.parse(element.firstElement())) {
                timeLine.addLayer(layer);
            }
        }

        return timeLines;
    }

    static function get_instance():DOMTimeLineAssembler
    {
        if (null == _instance)
            _instance = new DOMTimeLineAssembler();

        return _instance;
    }
}