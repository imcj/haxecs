package hx.geom;

class Matrix
{
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var d:Float;
    public var tx:Float;
    public var ty:Float;

    public function new(a=1.0, b=0.0, c=0.0, d=1.0, tx=0.0, ty=0.0)
    {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.tx = tx;
        this.ty = ty;
    }

    public function sub(matrix:Matrix):Matrix
    {
        return new Matrix(a - matrix.a, b - matrix.b, c - matrix.c, d - matrix.d, tx - matrix.tx, ty - matrix.ty);
    }

    public function add(matrix:Matrix):Matrix
    {
        return new Matrix(a + matrix.a, b + matrix.b, c + matrix.c, d + matrix.d, tx + matrix.tx, ty + matrix.ty);
    }

    public function multi(num:Float):Matrix
    {
        return new Matrix(a * num, b * num, c * num, d * num, tx * num, ty * num);
    }

    public function div(num:Float):Matrix
    {
        return new Matrix(a / num, b / num, c / num, d / num, tx / num, ty / num);
    }

    public function toFlashMatrix():flash.geom.Matrix
    {
        return new flash.geom.Matrix(a, b, c, d, tx, ty);
    }
}