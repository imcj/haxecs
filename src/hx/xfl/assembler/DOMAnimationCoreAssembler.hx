package hx.xfl.assembler;

import hx.xfl.assembler.XFLBaseAssembler;
import hx.xfl.motion.PropertyContainer;

class DOMAnimationCoreAssembler extends XFLBaseAssembler
{

    public function new(document)
    {
        super(document);
    }

    public function parse(data:Xml):DOMAnimationCore
    {
        var animation = new DOMAnimationCore();
        fillProperty(animation, data);
        for (element in data.elements()) {
            if ("PropertyContainer" == element.nodeName) {
                var pContainer = new PropertyContainer();
                fillProperty(pContainer, element);
                pContainer.parse(element);
                animation.PropertyContainers.push(pContainer);
            }
        }
        return animation;
    }
}