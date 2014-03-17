package hx.xfl.assembler;

class DOMTimeLineAssembler extends XFLBaseAssembler
{
    var layerAssembler:DOMLayerAssembler;

    public function new(document:XFLDocument)
    {
        super(document);
        layerAssembler = new DOMLayerAssembler(document);
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
}