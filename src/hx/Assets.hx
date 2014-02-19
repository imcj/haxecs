package hx;

#if openfl
import flash.display.Bitmap;
import flash.display.PixelSnapping;

class Assets
{
    static var hook:AssetsHook;

    static public function setHook(hook:AssetsHook):Void
    {
        Assets.hook = hook;
    }

    static public function getBitmap(name:String):Bitmap
    {
        var bitmap:Bitmap;
        bitmap = new Bitmap(openfl.Assets.getBitmapData(name),
                PixelSnapping.AUTO, true);

        if (null != hook)
            hook.afterGetBitmap(bitmap);
        return bitmap;
    }

    static public function getText(name:String):String
    {
        return openfl.Assets.getText(name);
    }
}
#end