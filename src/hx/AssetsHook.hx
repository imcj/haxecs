package hx;

#if openfl
import flash.display.Bitmap;

interface AssetsHook
{
    function afterGetBitmap(bitmap:Bitmap):Bitmap;
}
#end