package hx.xfl.motion;

class PropertyContainer
{
    public var id:String;
    public var children:Array<Dynamic>;

    public function new()
    {
        id = "";
        children = [];
    }

    public function parse(data:Xml)
    {
        for (element in data.elements()) {
            if ("PropertyContainer" == element.nodeName) {
                var pContainer = new PropertyContainer();
                pContainer.id = element.get("id");
                pContainer.parse(element);
                children.push(pContainer);
            }else {
                var property = new Property();
                property.parse(element);
                children.push(property);
            }
        }
    }
}