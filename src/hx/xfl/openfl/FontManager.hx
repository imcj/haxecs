package hx.xfl.openfl;

import flash.text.Font;

class FontManager
{
    static public var shared(get, null):FontManager;
    static var _shared:FontManager;
    var _fonts:Map<String, Font>;

    public function new()
    {
        _fonts = new Map<String, Font>();
        for (font in Font.enumerateFonts(true)) {
            _fonts.set(clean(font.fontName), font);
        }
    }

    function clean(font:String):String
    {
        var last = font.lastIndexOf("/");
        if (-1 == last)
            return font;
        else
            return font.substring(last + 1);
    }

    public function get(fontName:String):Font
    {
        return _fonts.get(fontName);
    }

    public function set(fontName:String, font:Font):Void
    {
        _fonts.set(fontName, font);
    }

    static function get_shared():FontManager
    {
        if (null == _shared)
            _shared = new FontManager();
        return _shared;
    }
}