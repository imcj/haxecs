package hx.xfl;

import hx.geom.Matrix;

interface IDOMElement
{
    var frame:DOMFrame;
    var libraryItemName(default, default):String;
    var matrix(default, default):Matrix;
    var centerPoint3DX(default, default):Float;
    var centerPoint3DY(default, default):Float;
}