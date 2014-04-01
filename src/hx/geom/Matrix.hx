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

    public function rotate(angle:Float):Void 
    {
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var a1 = a * cos - b * sin;
        b = a * sin + b * cos;
        a = a1;
        var c1 = c * cos - d * sin;
        d = c * sin + d * cos;
        c = c1;
        //var tx1 = this.tx * cos - this.ty * sin;
        //this.ty = this.tx * sin + this.ty * cos;
        //this.tx = tx1;
    }

    public function scale(x:Float, y:Float):Void 
    {
        a *= x;
        b *= y;
        c *= x;
        d *= y;
        //tx *= x;
        //ty *= y;
    }

    public function setSkew(x:Float, y:Float):Void 
    {
        a = Math.cos(y);
        b = Math.sin(y);
        c = -Math.sin(x);
        d = Math.cos(x);
    }

    public function skew(x:Float, y:Float):Void 
    {
        var cosY = Math.cos(y);
        var sinY = Math.sin(y);
        var a1 = a * cosY - sinY * b;
        b = b * cosY + a * sinY;
        a = a1;
        var cosX = Math.cos(x);
        var sinX = Math.sin(x);
        var c1 = c * cosX - d * sinX;
        d = d * cosX + c * sinX;
        c = c1;
    }

    public function translate(x=0.0, y=0.0, point=null):Void 
    {
        if (null == point) {
            tx += x;
            ty += y;
        }else {
            tx += point.x;
            ty += point.y;
        }
        
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