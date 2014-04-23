package hx.cs;

import hx.xfl.*;
import as3hx.Parser;
import as3hx.Writer;
import as3hx.As3;

import hx.cs.CSParser;

import sys.io.File;

using StringTools;
using Lambda;
using hx.helper.StringHelper;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class Run
{
    var document:XFLDocument;
    var fla_path:String;
    var target:String;

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
            switch (option) {
            case "-h", "--help":
                usage();
            }
        }

        fla_path = arguments[0];
        if (fla_path.endsWith(".fla")) {
            Lib.print("暂时不支持直接操作fla文件，请使用Flash CS另存为xfl格式。\n");
            Sys.exit(0);
        }

        if (sys.FileSystem.exists(fla_path)) {
            if (sys.FileSystem.isDirectory(fla_path)) {
                var xfls:Array<String> = [];
                for (item in sys.FileSystem.readDirectory(fla_path)) {
                    if (item.endsWith(".xfl")) {
                        fla_path += item;
                        xfls.push(item);
                    }
                }

                if (xfls.length > 1) {
                    Lib.print("存在多个xfl文件，请使用完整的路径。\n");
                    Sys.exit(0);
                }
            } else {

            }
        } else {
            Lib.print("文件不存在。\n");
            Sys.exit(0);
        }

        document = XFLDocument.open(fla_path);

        if (2 <= arguments.length) {
            target = arguments[1];
        }

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


    function usage()
    {
        var usage_text = "CSTool 1.0.0 (C) 2014 CJ\n\n" +
        "Usage: haxelib run haxecs fla [target]\n\n"  +
        "Options:\n\n" +
        "-h --help 打印帮助信息。\n" +
        "";

        Lib.print(usage_text);
        Sys.exit(0);
    }

    static public function main()
    {
        (new Run());
    }

    function createOpenFlProject(name:String)
    {
        var cwd = Sys.getCwd();

        var target_dir:String = target;
        if (!target.startsWith("/")) {
            target_dir = Path.join(Sys.getCwd(), [target]);
        }

        if (sys.FileSystem.exists(Path.join(target, ["project.xml"])))
            return;

        var up:String = Path.abspath(Path.join(target_dir, ["../"]));

        if (!sys.FileSystem.exists(up))
            sys.FileSystem.createDirectory(up);
        Sys.setCwd(up);
        Sys.command("haxelib", ["run", "lime", "create", "openfl:project", 
            name]);
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

        emptyClass("Main", "flash.display.MovieClip");

        for (timeline in document.getTimeLinesIterator()) {
            var class_name:String = "Main";
            var base_class_name = "flash.display.MovieClip";

            var class_content = emptyClass(class_name, base_class_name);

            generateFrameCode(timeline)

        }

        var class_name:String;
        var base_class_name:String;

        
        for (symbol in document.getSymbolIterators()) {
            var loadFromFile = false;

            // exportAsSource(timeline, )
            var frames:Array<Int> = [];

            var frame_code:String = generateFrameCode(symbol.timeline, frames);
            var needExport:Bool =
                symbol.linkageExportForAS || frames.length > 0;

            var class_content:String = null;

            if (!symbol.linkageExportForAS && frames.length > 0) {
                class_name = ~/([^A-Za-z_])/g.replace(symbol.name, "_");
                base_class_name = "flash.display.MovieClip";
                class_content = emptyClass(class_name, base_class_name);
            } else if (symbol.linkageExportForAS) {
                class_name = symbol.linkageClassName;
                base_class_name = symbol.linkageBaseClass;
                var class_file = getClassFile(class_name);
                if (null == class_file) {
                    class_content = emptyClass(class_name, base_class_name);
                } else {
                    class_content = sys.io.File.getContent(class_file);
                }
            }

            if (needExport) {
                exportAsSource(class_name, frame_code, class_content, frames);
            }
        }
    }

    inline function exportAsSource(class_name:String, frame_code:String,
        class_content:String, frames:Array<Int>)
    {
        var complex = splitClassName(class_name);
        var ast:Program;
        ast = CSParser.toAST(class_content);

        var frame_ast = CSParser.toAST(frame_code);
        ast.typesDefd[0].fields = ast.typesDefd[0].fields.concat(
            frame_ast.typesDefd[0].fields);

        if (0 < frames.length) {
            var fields:Array<ClassField> = cast ast.typesDefd[0].fields;
            addFrameCodeIntoMovieClipConstructor(fields, frames,
                complex.class_name);
        }

        var class_directory = null;
        if (complex.package_name != "")
            class_directory = complex.package_name.replace(".", "/")
        else 
            class_directory = complex.package_name;

        var haxe_class_file = Path.join(Sys.getCwd(), [target, "Source", 
            class_directory, complex.class_name + ".hx"]);

        trace(haxe_class_file);
        File.saveContent(haxe_class_file, CSParser.toString(ast));
    }

    inline function generateFrameCode(timeline:DOMTimeLine, frames:Array<Int>)
    {
        var frame_codes:Map<Int, Array<String>> = getFrameCodes(timeline);
        var pack_frame_codes:Array<String>;

        var text_code = "package {\nclass FrameCode\n{\n";

        for (index in frame_codes.keys()) {
            var codes = frame_codes.get(index);
            if (null != codes) {
                text_code += '\nfunction _haxecs_frame_${index}()\n{\n'+
                    codes.join("\n") + "\n}\n";
                frames.push(index);
            }
        }

        return text_code + "\n}\n}";
    }

    inline function generateMainMovieClipFrameCode(
        timelines:Iterator<DOMTimeLine>, class_name:String, 
        base_class_name:String, frames:Array<Int>)
    {
            

        var main_code = "package {\nclass " + class_name + " extends " + 
            base_class_name + "\n{\n";
        for (timeline in timelines) {
            var frame_codes:Map<Int, Array<String>> = getFrameCodes(timeline);
            var sceneName:String = ~/[\s]+/g.replace(timeline.name, "_");

            for (index in frame_codes.keys()) {
                var codes = frame_codes.get(index);

                if (null != codes) {
                    text_code += '\nfunction _haxecs_frame_${index}()\n{\n'+
                        codes.join("\n") + "\n}\n";
                    frames.push(index);
                }
            }
        }

        return text_code + "\n}\n}";
    }

    inline function getFrameCodes(timeline:DOMTimeLine):Map<Int, Array<String>>
    {
        var frame_codes:Map<Int, Array<String>> = new Map();
        var per_frame_codes:Array<String>;

        for (layer in timeline.getLayersIterator()) {
            for (frame in layer.getFramesIterator()) {
                if (null != frame.actionScript) {
                    if (!frame_codes.exists(frame.index))
                        frame_codes.set(frame.index, new Array<String>());

                    per_frame_codes = frame_codes.get(frame.index);
                    per_frame_codes.push(frame.actionScript);
                }
            }
        }

        return frame_codes;
    }

    inline function addFrameCodeIntoMovieClipConstructor(
        fields:Array<ClassField>, frame_indexes:Array<Int>, class_name:String)
    {
        var frames:Array<Expr> = [];
        for (index in frame_indexes)
            frames.push(EConst(CInt(Std.string(index))));
        for (field in fields) {
            switch (field.kind) {
            case FFun(f):
                if (field.name == class_name) {
                    switch(f.expr) {
                    case EBlock(e):
                        e.push(ECall(EIdent("addFrames"),
                            [EArrayDecl(frames)]));
                    default:
                    }
                }
            default:
            }
        }
    }
}