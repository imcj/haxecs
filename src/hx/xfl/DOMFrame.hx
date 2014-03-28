package hx.xfl;

class DOMFrame
{
    public var layer:DOMLayer;
    public var duration:Int;
    public var tweenType:String;
    public var motionTweenSnap:Bool;
    public var index:Int;
    public var keyMode:Int;
    public var actionscript:String;
    public var motionTweenRotate:String;
    public var motionTweenScale:Bool;
    public var isMotionObject:Bool;
    public var visibleAnimationKeyframes:Int;

    public var elements:Array<IDOMElement>;

    public function new()
    {
        layer = null;
        duration = 1;
        tweenType = null;
        motionTweenSnap = false;
        index = -1;
        keyMode = -1;
        actionscript = null;
        elements = [];
        motionTweenRotate = "";
    }

    public function addElement(element:IDOMElement):DOMFrame
    {
        element.frame = this;
        elements.push(element);
        return this;
    }

    public function getElementsIterator():Iterator<IDOMElement>
    {
        return elements.iterator();
    }

    public function forEachElement(Function:IDOMElement->Bool):Void
    {
        for (element in elements)
            if (!Function(element))
                break;
    }
}