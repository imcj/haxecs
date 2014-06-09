package hx.xfl;

class DOMFrame
{
    public var actionScript:String;
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
    public var name:String;
    public var visibleAnimationKeyframes:Int;
    // none name comment anchor
    public var labelType:String;
    public var hasCustomEase:Bool;
    public var motionTweenOrientToPath:Bool;
    // none auto clockwise counter-clockwise
    public var motionTweenRotateTimes:Int;
    public var motionTweenSync:Bool;
    // distributive angular
    public var shapeTweenBlend:String;
    // none "left channel" "right channel" "fade left to right"
    // "fade right to left" "fade in" "fade out" "custom"
    public var soundEffect:String;
    public var soundLibraryItem:DOMSoundItem;
    public var soundLoop:Int;
    // "repeat" "loop"
    public var soundLoopMode:String;
    public var soundName:String;
    // "event" "stop" "start" "stream"
    public var soundSync:String;
    public var startFrame:Int;
    public var tweenEasing:Int; // -100 100
    public var tweenInstanceName:String;
    // "motion" "shape" "none"
    public var useSingleEaseCurve:Bool;

    public var elements:Array<IDOMElement>;
    public var animation:DOMAnimationCore;

    public function new()
    {
        layer = null;
        duration = 0;
        tweenType = null;
        motionTweenSnap = false;
        index = -1;
        keyMode = -1;
        actionscript = null;
        elements = [];
        motionTweenRotate = "";
        animation = null;
        name = null;
        labelType = "";
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