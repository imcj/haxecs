package hx.xfl.graphic;

class Edge
{
    public var fillStyle1:Int;
    public var fillStyle0:Int;
    public var strokeStyle:Int;
    public var edges:Array<EdgeCommand>;

    public function new()
    {
        fillStyle1 = 0;
        fillStyle0 = 0;
        strokeStyle = 0;
        edges = [];
    }

    //重制edges数据，连接绘制区域，去除多余的moveTo
    public function rebuild():Void 
    {
        var tempEdges = edges.copy();
        edges = [];
        var area:Array<EdgeCommand> = [];
        while (tempEdges.length > 0) {
            var n = 0;
            while (n < tempEdges.length - 1) {
                var e = tempEdges[n];
                if (area.length == 0) {
                    area.push(e);
                    area.push(tempEdges[n + 1]);
                    tempEdges.remove(tempEdges[n + 1]);
                    tempEdges.remove(e);
                    continue;
                }else {
                    var lastEdge = area[area.length - 1];
                    if ("curveTo" != lastEdge.type &&
                        e.x == lastEdge.x &&
                        e.y == lastEdge.y) {
                        area.push(tempEdges[n + 1]);
                        tempEdges.remove(tempEdges[n + 1]);
                        tempEdges.remove(e);
                        n = 0;
                        continue;
                    }else if ("curveTo" == lastEdge.type &&
                              e.x == lastEdge.anchorX &&
                              e.y == lastEdge.anchorY) {
                        area.push(tempEdges[n + 1]);
                        tempEdges.remove(tempEdges[n + 1]);
                        tempEdges.remove(e);
                        n = 0;
                        continue;
                    }
                }
                n += 2;
            }
            edges = edges.concat(area);
            area = [];
        }
    }

    //转变为fillstyle1的Edge,用于将fillstyle0的数据转换为fillstyle1
    //以便将fillstyle1形成闭合图形
    public function toFillStyle1():Edge
    {
        if (this.fillStyle0 == 0) {
            return this.clone();
        }
        var edge = this.clone();
        edge.fillStyle1 = edge.fillStyle0;
        var edges = [];
        var n = 0;
        while (n < edge.edges.length) {
            var star = edge.edges[n];
            var end = edge.edges[n + 1];
            var temp = end.clone();
            end.type = star.type;
            star.type = temp.type;
            if ("curveTo" == star.type) {
                end.x = end.anchorX;
                end.y = end.anchorY;
                star.anchorX = star.x;
                star.anchorY = star.y;
                star.x = temp.x;
                star.y = temp.y;
            }
            edges.push(end);
            edges.push(star);
            n += 2;
        }
        edge.edges = edges;
        return edge;
    }

    public function clone():Edge
    {
        var edge = new Edge();
        edge.fillStyle0 = this.fillStyle0;
        edge.fillStyle1 = this.fillStyle1;
        edge.strokeStyle = this.strokeStyle;
        for (e in this.edges) {
            edge.edges.push(e.clone());
        }
        return edge;
    }

    public function toString():String
    {
        var str = "\nEdge:\n";
        if(this.fillStyle0 != 0)str += "\tfillStyle0:" + this.fillStyle0 + "\n";
        if(this.fillStyle1 != 0)str += "\tfillStyle1:" + this.fillStyle1 + "\n";
        str += "\tstrokeStyle:" + this.strokeStyle + "\n";
        str += "\tedges[" + this.edges.length + "]:\n";
        for (e in this.edges) {
            str += "\t\t" + e.toString() + "\n";
        }
        return str;
    }
}