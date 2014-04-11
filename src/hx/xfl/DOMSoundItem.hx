package hx.xfl;

class DOMSoundItem extends DOMItem
{
    public var bitRate:String;
    public var bits:String;
    public var compressionType:String;
    public var convertStereoToMono:Bool;
    public var fileLastModifiedDate:String;
    public var originalCompressionType:String;
    public var quality:String;
    public var sampleRate:String;
    public var sourceFileExists:Bool;
    public var sourceFileIsCurrent:Bool;
    public var sourceFilePath:String;
    public var useImportedMP3Quality:Bool;
    public var soundDataHRef:String;
    public var itemID:String;
    public var sourceLastImported:String;
    public var externalFileSize:Int;
    public var href:String;
    public var format:String;
    public var sampleCount:Int;
    public var dataLength:Int;

    public function new()
    {
        super();
    }
}