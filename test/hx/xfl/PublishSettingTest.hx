package hx.xfl;

import massive.munit.Assert;

class PublishSettingTest
{
    public function new()
    {
    }

    // public function toCamelCase(name:String):String
    // {
    //     var isUp = ~/[A-Z]/g;
    //     if (!isUp.match(name.substr(0, 1)))
    //         return name;

    //     var i = 0;
    //     var size = name.length;
    //     var converted:Array<String> = [];
    //     for (letter in name.split("")) {
    //         if (isUp.match(letter))

    //     }
    //     return "";
    // }

    @TestDebug
    public function testAS3Path()
    {
        var document = XFLDocument.open("example/piratepig/Assets/ASPiratePig");

        Assert.areEqual(".", 
            document.flashProfiles.Default.flashProperties.as3PackagePaths[0]);
    }
}