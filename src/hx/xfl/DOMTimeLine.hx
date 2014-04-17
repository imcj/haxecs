package hx.xfl;

class DOMTimeLine
{
    public var document:XFLDocument;
    public var name:String;
    public var layers:Array<DOMLayer>;
    public var mapLayers:Map<String, DOMLayer>;
    public var currentFrame:Int;
    public var totalFrames:Int;
    
    public function new()
    {
        document = null;
        name = null;
        layers = [];
        mapLayers = new Map();
        totalFrames = 0;
    }

    public function addLayer(layer:DOMLayer):DOMTimeLine
    {
        layer.timeLine = this;
        layers.push(layer);
        mapLayers.set(layer.name, layer);
        if (totalFrames < layer.totalFrames) totalFrames = layer.totalFrames;
        return this;
    }

    public function getLayer(name:String):DOMLayer
    {
        return mapLayers.get(name);
    }

    public function getLayersIterator(asc:Bool=true):Iterator<DOMLayer>
    {
        return new hx.xfl.utils.ArrayIterator(layers, asc);
    }
}