package hx.xfl;

import hx.geom.Matrix;

interface IDOMElement
{
    var name:String;
    var frame:DOMFrame;
    var libraryItemName(default, default):String;
    var matrix(default, default):Matrix;
    var centerPoint3DX(default, default):Float;
    var centerPoint3DY(default, default):Float;
    var width(default, default):Float;
    var height(default, default):Float;
}