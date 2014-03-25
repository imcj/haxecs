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

    //转变为fillstyle1的Edge,用于将fillstyle0的数据转换为fillstyle1
    //以便将fillstyle1形成闭合图形
    public function toFillStyle1():Edge
    {
        if (this.fillStyle0 == 0) {
            return this.clone();
        }
        var edge:Edge;
        edge = this.clone();
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

    public function reverse():Void 
    {
        var areas = getAreas();

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

    public function alignByVectors():Void 
    {
        var areas = getAreas();
        var vectors = vectorsByClockwise();
        edges = [];
        for (v in vectors) {
            edges = edges.concat(areas[v.index]);
        }
    }

    function vectorsByClockwise():Array<{starX:Float,starY:Float,angle:Float,index:Int}>
    {
        var vectors = getAreasVectors();
        vectors.sort(function (a,b):Int 
        {
            if (a.angle != b.angle)
                return Reflect.compare(a.angle, b.angle);
            else 
                return -Reflect.compare(a.starX, b.starX);
        });
        return vectors;
    }

    function getAreasVectors():Array<{starX:Float,starY:Float,angle:Float,index:Int}>
    {
        var vectors = [];
        var areas = getAreas();
        var n = 0;
        for (area in areas) {
            var vector:Dynamic = { };
            vector.starX = area[0].x;
            vector.starY = area[0].y;
            var endEdgeCommand = area[area.length - 1];
            var endX, endY;
            if ("lineTo" == endEdgeCommand.type) {
                endX = endEdgeCommand.x;
                endY = endEdgeCommand.y;
            }else {
                endX = endEdgeCommand.anchorX;
                endY = endEdgeCommand.anchorY;
            }
            vector.angle = Math.atan2(endY - vector.starY, endX - vector.starX);
            vector.index = n;
            n++;

            vectors.push(vector);
        }
        return vectors;
    }

    function getAreas():Array<Array<EdgeCommand>>
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
        return areas;
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

    public function toString():String
    {
        var str = "\nEdge:\n";
        if(this.fillStyle0 != 0)str += "\tfillStyle0:" + this.fillStyle0 + "\n";
        if(this.fillStyle1 != 0)str += "\tfillStyle1:" + this.fillStyle1 + "\n";
        str += "\tstrokeStyle:" + this.strokeStyle + "\n";
        str += "\tedges:\n";
        for (e in this.edges) {
            str += "\t\t" + e.toString() + "\n";
        }
        return str;
    }
}