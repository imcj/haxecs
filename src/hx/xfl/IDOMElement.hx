package hx.xfl;

import hx.geom.ColorTransform;
import hx.geom.Matrix;
import hx.geom.Point;
import hx.xfl.filter.Filter;

interface IDOMElement
{
    var name:String;
    var frame:DOMFrame;
    var matrix(default, default):Matrix;
    var transformPoint(default, default):Point;
    var centerPoint3DX(default, default):Float;
    var centerPoint3DY(default, default):Float;
    var width(default, default):Float;
    var height(default, default):Float;
    var colorTransform(default, default):ColorTransform;
    var filters(default, default):Array<Filter>;
}