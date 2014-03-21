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

    //重制edges数据，去除多余的moveTo
    public function rebuild():Void 
    {
        var n = 1;
        while (n < edges.length) {
            if (edges[n - 1].type != "curveTo" &&
                edges[n-1].x == edges[n].x &&
                edges[n-1].y == edges[n].y) {
                edges.remove(edges[n]);
            }else if (edges[n - 1].type == "curveTo" &&
                edges[n-1].anchorX == edges[n].x &&
                edges[n-1].anchorY == edges[n].y) {
                edges.remove(edges[n]);
            }else {
                n++;
            }
        }
    }

    public function reverse():Void 
    {
        var areas = [];
        var fillArea = [];
        for (e in edges) {
            if (e.type == "moveTo") {
                if (fillArea.length > 0) {
                    areas.push(fillArea.copy());
                    fillArea = [];
                }
            }
            fillArea.push(e.clone());
        }
        if (fillArea.length > 0) {
            areas.push(fillArea.copy());
        }

        var reversAreas = [];
        for (area in areas) {
            var reversArea = [];
            for (n in 0...area.length) {
                reversArea.push(area.pop());
            }
            if (reversArea[0].type != "curveTo") {
                reversArea[0].type = "moveTo";
                reversArea[reversArea.length - 1].type = "lineTo";
            }else {
                reversArea[0].type = "moveTo";
                reversArea[reversArea.length - 1].type = "curveTo";
                reversArea[reversArea.length - 1].anchorX = reversArea[0].anchorX;
                reversArea[reversArea.length - 1].anchorY = reversArea[0].anchorY;
            }
            
            reversAreas.push(reversArea);
        }

        edges = [];
        for (a in reversAreas) {
            edges = edges.concat(a);
        }
    }

    public function clone():Edge
    {
        var edge = new Edge();
        edge.fillStyle0 = this.fillStyle0;
        edge.fillStyle1 = this.fillStyle1;
        edge.strokeStyle = this.strokeStyle;
        edge.edges = this.edges.copy();

        return edge;
    }
}