package hx.xfl;

class DOMItem
{
    public var name:String;
    public var linkageClassName:String;
    public var linkageExportForAS:Bool;
    public var linkageBaseClass:String;
    public var linkageExportForRS:Bool;
    public var linkageExportInFirstFrame:Bool;
    public var linkageIdentifier:String;
    public var linkageImportForRS:Bool;
    public var linkageURL:String;
    public var itemType:String;

    public function new()
    {
        linkageClassName = null;
    }
}