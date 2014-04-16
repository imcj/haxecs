package hx.xfl.assembler;

import hx.geom.Matrix;
import hx.xfl.DOMShape;
import hx.xfl.graphic.Edge;
import hx.xfl.graphic.EdgeCommand;
import hx.xfl.graphic.FillStyle;
import hx.xfl.graphic.StrokeStyle;

class DOMShapeAssembler extends DOMElementAssembler
                        implements IDOMElementAssembler
{

    public function new(document)
    {
        super(document);
    }
    
    override public function parse(data:Xml):IDOMElement {
        var instance = cast(super.parse(data), DOMShape);
        if (data.exists("libraryItemName")) {
            var i = document.library.findItemIndex(data.get("libraryItemName"));
            instance.libraryItem = cast(document.library.items[i],
                DOMSymbolItem);
        }

        // 解析矢量图绘制数据
        for (element in data.elements()) {
            if ("fills" == element.nodeName) {
                for (fill in element.elements()) {
                    if ("SolidColor" == fill.firstElement().nodeName) {
                        var fillStyle = new FillStyle();
                        fillProperty(fillStyle, fill);
                        fillStyle.type = fill.firstElement().nodeName;
                        var c = "0x"+fill.firstElement().get("color").substring(1);
                        fillStyle.color = Std.parseInt(c);
                        var alpha = fill.firstElement().get("alpha");
                        if(alpha != null)fillStyle.alpha = Std.parseFloat(alpha);
                        instance.fills.set(fillStyle.index, fillStyle);
                    }
                    if ("RadialGradient" == fill.firstElement().nodeName) {
                        var fillStyle = new FillStyle();
                        fillStyle.type = fill.firstElement().nodeName;
                        for (e in fill.firstElement().elements()) {
                            if ("matrix" == e.nodeName) {
                                var matrix = new Matrix();
                                matrix.setByXml(e);
                                fillStyle.matrix = matrix;
                            }
                        }
                        instance.fills.set(fillStyle.index, fillStyle);
                    }
                }
            }else if ("strokes" == element.nodeName) {
                for (stroke in element.elements()) {
                    if ("SolidStroke" == stroke.firstElement().nodeName) {
                        var strokeStyle = new StrokeStyle();
                        fillProperty(strokeStyle, stroke);
                        strokeStyle.type = stroke.firstElement().nodeName;
                        fillProperty(strokeStyle, stroke.firstElement());
                        var c = stroke.firstElement().firstElement().firstElement().get("color");
                        if (null != c)
                            c = "0x" + c.substring(1);
                        else
                            c = "0x0";
                        strokeStyle.color = Std.parseInt(c);
                        instance.strokes.set(strokeStyle.index, strokeStyle);
                    }
                }
            }else if ("edges" == element.nodeName){
                for (edgeXml in element.elements()) {
                    if (null != edgeXml.get("cubics")) continue;
                    var edge = new Edge();
                    fillProperty(edge, edgeXml, ["edges"]);
                    //解析绘制
                    var edges = edgeXml.get("edges");
                    edges = StringTools.replace(edges, "!", "$!");
                    edges = StringTools.replace(edges, "|", "$|");
                    edges = StringTools.replace(edges, "[", "$[");
                    edges = StringTools.replace(edges, "\r", "");
                    edges = StringTools.replace(edges, "\n", "");
                    var edgesArr = edges.split("$");
                    for (com in edgesArr) {
                        if (com == " " || com == "")
                            continue;
                        var command = new EdgeCommand();
                        var values = parseNumbers(com);
                        command.x = values[0];
                        command.y = values[1];
                        if (com.indexOf("!") >= 0 ) {
                            command.type = "moveTo";
                        }
                        if (com.indexOf("|") >= 0 ) {
                            command.type = "lineTo";
                        }
                        if (com.indexOf("[") >= 0 ) {
                            command.type = "curveTo";
                            command.anchorX = values[2];
                            command.anchorY = values[3];
                        }
                        edge.edges.push(command);
                    }

                    instance.edges.push(edge);

                    //获得填充数据，对fillstyle0和fillstyle1分开处理
                    //fillstyle0转为fillstyle1，然后再合并
                    if (edge.fillStyle1 != 0) {
                        var e = instance.fillEdges1.get(edge.fillStyle1);
                        if (null == e) {
                            instance.fillEdges1.set(edge.fillStyle1, edge.clone());
                        }else {
                            e.edges = e.edges.concat(edge.clone().edges);
                        }
                    }
                    if (edge.fillStyle0 != 0) {
                        var edgeTofill1 = edge.toFillStyle1();
                        var e = instance.fillEdges1.get(edgeTofill1.fillStyle1);
                        if (null == e) {
                            instance.fillEdges1.set(edgeTofill1.fillStyle1, edgeTofill1);
                        }else {
                            e.edges = e.edges.concat(edgeTofill1.edges);
                        }
                    }
                }
            }
        }

        //重制填充数据，连接填充区域
        for (f1 in instance.fillEdges1) {
            f1.rebuild();
        }

        return instance;
    }

    function parseNumbers(str:String):Array<Float>
    {
        var values:Array<Float> = [];
        str = str.substring(1);
        var strArr = str.split(" ");
        for (vStr in strArr) {
            //忽略S及其以后数据
            var indexS = vStr.indexOf("S");
            if (indexS >= 0) {
                vStr = vStr.substring(0, indexS);
            }
            //解析16进制数据，忽略小数点后的数据
            var indexHash = vStr.indexOf("#");
            if (indexHash >= 0) {
                vStr = "0x" + vStr.substring(1);
                var indexDecimal=   vStr.indexOf(".");
                if (indexDecimal >= 0) {
                    vStr = vStr.substring(0, indexDecimal);
                }
            }
            values.push(Std.parseInt(vStr)/20);
        }
        return values;
    }

    override public function createElement():IDOMElement {
        return new DOMShape();
    }
}