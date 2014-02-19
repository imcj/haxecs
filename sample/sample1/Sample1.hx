package ;

import sys.io.File;

import hx.xfl.DOMFrame;
import hx.xfl.DOMBitmapInstance;

class Sample1
{
    public function new():Void
    {
        var document = hx.xfl.XFLDocument.open(
            "/Users/weicongju/Projects/hoohou/jewel/");

        for (bitmapItem in document.getMediaIterator()) {
            printBitmapItem(bitmapItem);
        }

        for (timeline in document.getTimeLinesIterator()) {
            trace('Time line ${timeline.name}.');
            for (layer in timeline.getLayersIterator(false)) {
                printLayer(layer);
                for (frame in layer.getFramesIterator()) {
                    printFrame(frame);
                    for (element in frame.getElementsIterator()) {
                        if (Std.is(element, DOMBitmapInstance)) {
                            printBitmapInstance(cast(element,
                                DOMBitmapInstance));
                        }
                    }
                }
            }
        }
    }

    function printBitmapItem(bitmapItem)
    {
        trace('Bitmap item ${bitmapItem.name} id=${bitmapItem.itemID}' + 
              ' ${bitmapItem.sourceExternalFilepath}');
    }

    function printBitmapInstance(element:DOMBitmapInstance):Void
    {
        trace('Bitmap instance name is ${element.libraryItemName} at ' +
              '${element.matrix.tx},${element.matrix.ty}');
    }

    function printLayer(layer)
    {
        var line:String;
        line = 'Layer ${layer.name}';

        if (null != layer.color)
            line += ' color ${layer.color}';

        if (null != layer.autoNamed) {
            line += ' autoNamed ${layer.autoNamed}';
        }

        trace(line);
    }

    function printFrame(frame:DOMFrame)
    {
        var line:String;
        line = 'frame index ${frame.index}';

        if (frame.duration > -1) {
            line += ' duration ${frame.duration}';
        }

        if (frame.keyMode > -1) {
            line += ' keyMode ${frame.keyMode}.';
        }

        trace(line);
    }

    static public function main()
    {
        new Sample1();
    }
}