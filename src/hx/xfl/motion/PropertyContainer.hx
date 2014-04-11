package hx.xfl.motion;

class PropertyContainer
{
    public var id:String;
    public var children:Map<String, Dynamic>;

    public function new()
    {
        id = "";
        children = new Map<String, Dynamic>();
    }

    public function parse(data:Xml)
    {
        for (element in data.elements()) {
            if ("PropertyContainer" == element.nodeName) {
                var pContainer = new PropertyContainer();
                pContainer.id = element.get("id");
                pContainer.parse(element);
                children.set(pContainer.id, pContainer);
            }else {
                var property = new Property();
                property.parse(element);
                children.set(property.id, property);
            }
        }
    }
}