package hx.xfl.setting.publish;

class DOMFlashProfile
{
    public var name:String;
    public var version:String;
    public var current:Bool;

    public var flashProperties:DOMFlashProperties;

    public function new()
    {
        current = false;    
    }
}