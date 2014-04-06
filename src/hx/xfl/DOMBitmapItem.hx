package hx.xfl;

class DOMBitmapItem extends DOMItem
{
    public var allowSmoothing:Bool;
    public var characterId:Int;
    public var externalFileCRC32:Int;
    public var externalFileSize:Int;
    public var frameRight:Int;
    public var frameBottom:Int;
    public var id:Int;
    public var itemID:String;
    public var quality:Int;
    public var originalCompressionType:String;
    public var compressionType:String;
    public var href:String;
    public var bitmapDataHRef:String;
    public var isJPEG:Bool;
    public var useDeblocking:Bool;
    public var useImportedJPEGData:Bool;
    public var sourcePlatform:String;
    public var sourceExternalFilepath:String;
    public var sourceLastImported:String;

    public function new()
    {
        super();
        
        id = 0;
        characterId = 0;
        itemID = null;
        sourceExternalFilepath = null;
        sourceLastImported = null;
        useImportedJPEGData = false;
        quality = 0;
        originalCompressionType = null;
        compressionType = null;
        href = null;
        bitmapDataHRef = null;
        frameRight = 0;
        frameBottom = 0;
        isJPEG = false;
        externalFileSize = 0;
        allowSmoothing = false;
        useDeblocking = false;
        sourcePlatform = null;
    }
}