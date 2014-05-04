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

    public function setByXml(xml:Xml):Void 
    {
        var matrix_a:String, matrix_b:String, matrix_c:String, matrix_d:String,
            matrix_tx:String, matrix_ty:String;

        if ("matrix" == xml.nodeName) {
            matrix_a  = xml.firstElement().get('a');
            matrix_b  = xml.firstElement().get('b');
            matrix_c  = xml.firstElement().get('c');
            matrix_d  = xml.firstElement().get('d');
            matrix_tx = xml.firstElement().get('tx');
            matrix_ty = xml.firstElement().get('ty');

            if (null != matrix_a)
                a = Std.parseFloat(matrix_a);

            if (null != matrix_b)
                b = Std.parseFloat(matrix_b);

            if (null != matrix_c)
                c = Std.parseFloat(matrix_c);

            if (null != matrix_d)
                d = Std.parseFloat(matrix_d);

            if (null != matrix_tx)
                tx = Std.parseFloat(matrix_tx);

            if (null != matrix_ty)
                ty = Std.parseFloat(matrix_ty);
        }
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
    
    public function setRotate(angle:Float):Void 
    {
        a = Math.cos(angle);
        b = Math.sin(angle);
        c = -Math.sin(angle);
        d = Math.cos(angle);
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

    public function translate(?x=0.0, ?y=0.0, point=null):Void 
    {
        if (null == point) {
            tx += x;
            ty += y;
        }else {
            tx += point.x;
            ty += point.y;
        }
    }

    public function deltaTransformPoint(point:{x:Float, y:Float}):{x:Float, y:Float}
    {
        return new Point(point.x * a + point.y * c, point.x * b + point.y * d);
    }

    public function transformPoint(point:{x:Float, y:Float}):{x:Float, y:Float}
    {
        return new Point(point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
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

    #if (flash||cpp)
    public function toFlashMatrix():flash.geom.Matrix
    {
        return new flash.geom.Matrix(a, b, c, d, tx, ty);
    }
    #end

    public function clone():hx.geom.Matrix
    {
        var matrix = new Matrix();
        matrix.a = this.a;
        matrix.b = this.b;
        matrix.c = this.c;
        matrix.d = this.d;
        matrix.tx = this.tx;
        matrix.ty = this.ty;
        return matrix;
    }
}