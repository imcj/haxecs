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
                for (fill in element.firstElement().elements()) {
                    if ("SolidColor" == fill.nodeName) {
                        var fillStyle = new FillStyle();
                        fillProperty(fillStyle, element.firstElement());
                        fillStyle.type = fill.nodeName;
                        var c = "0x"+fill.get("color").substring(1);
                        fillStyle.color = Std.parseInt(c);
                        instance.fills.set(fillStyle.index, fillStyle);
                    }
                }
            }else if ("strokes" == element.nodeName) {
                for (stroke in element.firstElement().elements()) {
                    if ("SolidStroke" == stroke.nodeName) {
                        var strokeStyle = new StrokeStyle();
                        fillProperty(strokeStyle, element.firstElement());
                        strokeStyle.type = stroke.nodeName;
                        fillProperty(strokeStyle, stroke);
                        instance.strokes.set(strokeStyle.index, strokeStyle);
                    }
                }
            }else if ("edges" == element.nodeName){
                for (edgeXml in element.elements()) {
                    var edge = new Edge();
                    fillProperty(edge, edgeXml, ["edges"]);
                    //TODO
                    //解析绘制
                    var edges = edgeXml.get("edges");
                    edges = StringTools.replace(edges, "!", "$!");
                    edges = StringTools.replace(edges, "|", "$|");
                    edges = StringTools.replace(edges, "[", "$[");
                    var edgesArr = edges.split("$");
                    if (edgesArr[0] == "" || edgesArr[0] == " ") {
                        edgesArr.shift();
                    }
                    for (com in edgesArr) {
                        var command = new EdgeCommand();
                        if (com.indexOf("!") >= 0 ) {
                            command.type = "moveTo";
                            command.x = Std.parseInt(com.substr(1, 4))/20;
                            command.y = Std.parseInt(com.substr(6, 4))/20;
                        }
                        if (com.indexOf("|") >= 0 ) {
                            command.type = "lineTo";
                            command.x = Std.parseInt(com.substr(1, 4))/20;
                            command.y = Std.parseInt(com.substr(6, 4))/20;
                        }
                        edge.edges.push(command);
                    }
                    var n = 1;
                    while (n < edge.edges.length) {
                        if (edge.edges[n-1].x == edge.edges[n].x &&
                            edge.edges[n-1].y == edge.edges[n].y) {
                            edge.edges.remove(edge.edges[n]);
                        }else {
                            n++;
                        }
                    }
                    instance.edge = edge;
                }
            }
        }

        return instance;
    }

    override public function createElement():IDOMElement {
        return new DOMShape();
    }
}