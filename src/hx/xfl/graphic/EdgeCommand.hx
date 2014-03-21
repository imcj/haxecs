package hx.xfl.graphic;

class EdgeCommand
{
    public var type:String;
    public var x:Float;
    public var y:Float;
    public var anchorX:Float;
    public var anchorY:Float;

    public function new()
    {
        type = "";
        x = 0;
        y = 0;
        anchorX = 0;
        anchorY = 0;
    }

    public function clone():EdgeCommand
    {
        var command = new EdgeCommand();
        command.anchorX = this.anchorX;
        command.anchorY = this.anchorY;
        command.type = this.type;
        command.x = this.x;
        command.y = this.y;

        return command;
    }
}