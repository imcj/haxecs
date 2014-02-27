package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMBitmapInstance;

class DOMBitmapInstanceAssembler extends DOMElementAssembler
                                 implements IDOMElementAssembler
{
    static var _instance:DOMBitmapInstanceAssembler;
    static public var instance(get, null):DOMBitmapInstanceAssembler;

    public function new()
    {
        super();
    }

    override public function parse(data:Xml):DOMBitmapInstance
    {
        var element = super.parse(data);

        for (element in data.elements()) {
        }

        return cast(element, DOMBitmapInstance);
    }

    override public function createElement():IDOMElement
    {
        return new DOMBitmapInstance();
    }

    static function get_instance():DOMBitmapInstanceAssembler
    {
        if (null == _instance)
            _instance = new DOMBitmapInstanceAssembler();
        return _instance;
    }
}