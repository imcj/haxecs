package hx.geom;

class Matrix
{
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var d:Float;
    public var tx:Float;
    public var ty:Float;

    public function new(a=0, b=0, c=0, d=0, tx=0, ty=0)
    {
        this.a = a;
        this.a = b;
        this.c = c;
        this.d = d;
        this.tx = tx;
        this.ty = ty;
    }
}