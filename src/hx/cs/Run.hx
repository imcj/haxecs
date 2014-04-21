package hx.cs;

import hx.xfl.*;
import as3hx.Parser;
import as3hx.Writer;
import as3hx.As3;

import hx.cs.CSParser;

using StringTools;
using Lambda;
using hx.helper.StringHelper;

class Run
{
    var document:XFLDocument;

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
        document = XFLDocument.open(fla_path);

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

    function getClassFile(class_name:String):String
    {
        class_name += ".as";
        for (dir in cast(document.flashProfiles.Default.flashProperties
                         .as3PackagePaths, Array<Dynamic>)) {
            var file = Path.abspath(Path.join(document.dir, ["../", dir, class_name]));
            // trace(file);
            if (sys.FileSystem.exists(file)) {
                return file;
            }
        }

        return null;
    }

    function splitClassName(class_name:String):Dynamic
    {
        var g_package_name:String, g_class_name:String;
        var dot:Int = class_name.lastIndexOf(".");
        if (dot > -1) {
            g_package_name = class_name.substring(0, dot);
            g_class_name = class_name.substring(dot, class_name.length);
        } else {
            g_package_name = "";
            g_class_name = class_name;
        }

        return {
            package_name: g_package_name,
            class_name: g_class_name
        };
    }

    function emptyClass(class_name:String, base_class_name:String):String
    {
        var package_and_class_name = splitClassName(class_name);
        var code = 'package ${package_and_class_name.package_name}\n{\n' +
        'public class ${package_and_class_name.class_name}';
        if (null != base_class_name && "" != base_class_name) {
            code += " extends " + base_class_name;
        } else {
        }

        code += "\n{\n";
        code += '\n}\n}';

        return code;
    }

    function exportAsSources(document:XFLDocument)
    {
        // Feature
        // 生成构造DOM对象的代码，代替XML的解析方法

        var c:Program;
        c = emptyAST("Main", "flash.display.MovieClip");

        for (timeline in document.getTimeLinesIterator()) {
        }

        var class_name:String;
        var base_class_name:String;

        
        for (symbol in document.getSymbolIterators()) {
            var fields:Array<ClassField> = [];
            var frame_code:Map<Int, Array<String>> = new Map();

            for (layer in symbol.timeline.getLayersIterator()) {
                for (frame in layer.getFramesIterator()) {
                    if (null != frame.actionScript) {
                        if (!frame_code.exists(frame.index))
                            frame_code.set(frame.index, new Array<String>());
                        var codes:Array<String> = frame_code.get(frame.index);
                        codes.push(frame.actionScript);
                    }
                }
            }

            var text_code = "package {\n" +
                "class M\n{\n";

            var frames:Array<Int> = [];
            var add_frames:Array<Expr> = [];

            for (index in frame_code.keys()) {
                var codes = frame_code.get(index);
                if (null != codes) {
                    text_code += '\nfunction _haxecs_frame_${index}()\n{\n' +
                        codes.join("\n") + "\n}\n";
                    frames.push(index);

                    add_frames.push(EConst(CInt(Std.string(index))));
                }
            }

            text_code += "\n}\n}";

            var needExport:Bool = false;
            needExport = symbol.linkageExportForAS || fields.length > 0;

            if (needExport) {
                var ast:Program;
                var class_content:String = null;
                if (!symbol.linkageExportForAS) {
                    class_name = ~/([^A-Za-z_])/g.replace(symbol.name, "_");
                    base_class_name = "flash.display.MovieClip";

                    class_content = emptyClass(class_name, base_class_name);
                } else {
                    class_name = symbol.linkageClassName;
                    base_class_name = symbol.linkageBaseClass;
                    var class_file = getClassFile(class_name);

                    if (null == class_file) {
                        class_content = emptyClass(class_name, base_class_name);
                    } else {
                        class_content = sys.io.File.getContent(class_file);
                    }
                }

                ast = CSParser.toAST(class_content);

                var frame_ast = CSParser.toAST(text_code);
                ast.typesDefd[0].fields = ast.typesDefd[0].fields.concat(
                    frame_ast.typesDefd[0].fields);

                if (frame_code.keys().next() != null) {
                    var path = splitClassName(class_name);
                    var fields:Array<ClassField> = cast ast.typesDefd[0].fields;
                    for (field in fields) {
                        switch (field.kind) {

                        case FFun(f):
                            if (field.name == path.class_name) {

                                switch(f.expr) {
                                case EBlock(e):
                                    e.push(ECall(EIdent("addFrames"),
                                        [EArrayDecl(add_frames)]));
                                default:
                                }
                            }
                        default:
                        }
                    }

                    return;
                }
            }
        }
    }
}