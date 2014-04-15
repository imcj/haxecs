package hx.cs;

import hx.xfl.*;
import as3hx.ClassField;

using StringTools;

class Run
{
    public function new()
    {
        var arguments:Array<String> = [];
        var options:Array<String> = [];
        for (argument in Sys.args())
            if (argument.startsWith("-"))
                options.push(argument);
            else
                arguments.push(argument);

        for (option in options) {
            // option_name = option.substr
        }

        var fla_path = arguments[0];
        var document = XFLDocument.open(fla_path);

        createOpenFlProject("piratepig");
        exportAsSources(document);

        // 创建Sound对应的类文件。
        for (item in document.getMediaIterator()) {
            if (Std.is(item, DOMSoundItem)) {
                var soundItem:DOMSoundItem = cast(item);
                // soundItem.
            }
        }
    }

    static public function main()
    {
        (new Run());
    }

    function createOpenFlProject(name:String)
    {

    }

    function getASTDefinition(paths:Array<String>,
        class_name:String, base_class_name:String)
    {

    }

    function getASTDefinitionWithFile(file_path:Stirng)
    {
        
    }

    function exportFrameCode(parser:Parser, as:String)
    {
        // TODO 分析表达式的AST，在不修改分析器的状态的情况下。
    }

    function exportAsSources(document:XFLDocument)
    {
        // TODO
        // 为导出类附加帧代码

        // Feature
        // 生成构造DOM对象的代码，代替XML的解析方法

        var mainMovieClip

        var c:Program;
        // c = getASTDefinition(["src"], "Main", "flash.display.MovieClip");

        // for (timeline in document.getTimeLinesIterator()) {
        //     for (layer in timeline.getLayersIterator()) {
        //         for (frame in layer.getFramesIterator()) {
        //             // 如果有导出类
        //             c.defs[0].fields.push(exportFrame(frame.actionScript));
        //         }
        //     }
        // }

        var class_name:String;
        var base_class_name:String;

        for (symbol in document.getSymbolIterators()) {
            var fields:Array<ClassField> = [];
            for (layer in symbol.timeline.getLayersIterator()) {
                for (frame in layer.getFramesIterator()) {
                    if (null != frame.actionScript);
                        fields.push(exportFrameCode(frame.actionScript));
                }
            }

            var needExport:Bool = false;
            needExport = symbol.linkageExportForAS || fields.length > 0;

            if (needExport) {
                if (!symbol.linkageExportForAS) {
                    class_name = ~/([^A-Za-z_])/g.replace(symbol.name, "_");
                    base_class_name = "flash.display.MovieClip";
                } else {
                    class_name = symbol.linkageClassName;
                    base_class_name = symbol.linkageBaseClass;
                }

                c = getASTDefinition(["src"], class_name, base_class_name);
                c.fields = c.fields.concat(fields);

                var output = haxe.io.BytesOutput();
                writer.process(c, output);

                trace(output.getBytes());
                break;
            }
        }
    }
}