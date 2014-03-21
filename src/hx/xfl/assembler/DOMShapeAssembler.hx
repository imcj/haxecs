package hx.xfl.assembler;

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

        // TODO
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
                        fillStyle.alpha = Std.parseFloat(fill.firstElement().get("alpha"));
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
                    //TODO
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
                    //获得分类填充数据
                    if (edge.fillStyle0 != 0) {
                        instance.fillEdges0.push(edge.clone());
                    }
                    if (edge.fillStyle1 != 0) {
                        instance.fillEdges1.push(edge.clone());
                    }
                }
            }
        }
        //重制填充数据
        var preFill:Edge = null;
        var needDeleteFill = [];
        for (fill in instance.fillEdges0) {
            if (null != preFill &&
                fill.fillStyle0 == preFill.fillStyle0) {
                preFill.edges = preFill.edges.concat(fill.edges);
                needDeleteFill.push(fill);
            }else {
                preFill = fill;
            }
        }
        while (needDeleteFill.length > 0) {
            var fill = needDeleteFill.pop();
            instance.fillEdges0.remove(fill);
        }
        for (f in instance.fillEdges0) {
            f.rebuild();
        }

        //preFill = null;
        //needDeleteFill = [];
        //for (fill in instance.fillEdges1) {
            //if (null != preFill &&
                //fill.fillStyle1 == preFill.fillStyle1) {
                //preFill.edges = preFill.edges.concat(fill.edges);
                //needDeleteFill.push(fill);
            //}else {
                //preFill = fill;
            //}
        //}
        //while (needDeleteFill.length > 0) {
            //var fill = needDeleteFill.pop();
            //instance.fillEdges1.remove(fill);
        //}
        for (f in instance.fillEdges1) {
            f.rebuild();
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