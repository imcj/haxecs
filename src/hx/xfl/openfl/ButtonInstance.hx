package hx.xfl.openfl;

import flash.display.SimpleButton;
import flash.display.Sprite;
import hx.xfl.DOMSymbolInstance;
import hx.xfl.DOMSymbolItem;
import hx.xfl.openfl.display.MovieClip;

class ButtonInstance extends SimpleButton
{
    public var dom:DOMSymbolInstance;

    public function new(dom:DOMSymbolInstance) 
    {
        this.dom = dom;
        var document = dom.frame.layer.timeLine.document;
        var file:DOMSymbolItem = 
        cast(document.getSymbol(dom.libraryItem.name), DOMSymbolItem);

        var upState = new Sprite();
        var overState = new Sprite();
        var downState = new Sprite();

        var timeline = file.timeline;
        var movieClip = new MovieClip(timeline);
        movieClip.gotoAndStop(0);
        upState = movieClip;
        var movieClip = new MovieClip(timeline);
        movieClip.gotoAndStop(1);
        overState = movieClip;
        var movieClip = new MovieClip(timeline);
        movieClip.gotoAndStop(2);
        downState = movieClip;

        var hitTest = upState;
        if (hitTest.width == 0 || hitTest.height == 0)
            hitTest = overState;
        if (hitTest.width == 0 || hitTest.height == 0)
            hitTest = downState;

        super(upState, overState, downState, hitTest);
        this.transform.matrix = dom.matrix.toFlashMatrix();
    }
}