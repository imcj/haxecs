package hx.xfl.openfl;

class MovieClipFactory
{
    static public var instance(get, null):MovieClipFactory;
    static function get_instance():MovieClipFactory
    {
        if (instance == null) {
            instance = new MovieClipFactory();
        }
        return instance;
    }

    public function new()
    {
        if (instance != null) throw "MovieClipFactory是单列类";
    }

    public function create():Void 
    {
        
    }
}