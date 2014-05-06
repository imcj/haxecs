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

/* TODO
 *
 * 读取外部文档类和帧代码合并
 * 生成构造DOM对象的代码，代替XML的解析方法
 */
         
class Run
{
    var document:XFLDocument;
    var fla_path:String;
    var target:String;

    var process:Map<String, Bool>;

    public function new()
    {
        process = new Map();

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
        configurateProject();

        // 创建Sound对应的类文件。
        for (item in document.getMediaIterator()) {
            if (Std.is(item, DOMSoundItem)) {
                var soundItem:DOMSoundItem = cast(item);
                
                if (soundItem.linkageExportForAS)
                    exportSound(soundItem);
            }
        }
        exportAsSources(document);
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

    inline function configurateProject()
    {
        var project_xml_file = "";
        if(~/Windows/.match(Sys.environment().get("OS")))
            project_xml_file = Path.join(target, ['project.xml']);
        else 
            project_xml_file = Path.join(Sys.getCwd(), [target, 'project.xml']);
        var project_xml = Xml.parse(sys.io.File.getContent(project_xml_file));

        var element_haxelib_haxecs = Xml.createElement("haxelib");
        element_haxelib_haxecs.set('name', 'haxecs');

        var element_haxelib_assets = Xml.createElement("assets");
        element_haxelib_assets.set('path', document.dir);

        for (element in project_xml.elements()) {
            if (element.nodeName == "project") {
                element.addChild(element_haxelib_haxecs);
                // element.addChild(element_haxelib_assets);
            }
        }

        sys.io.File.saveContent(project_xml_file, project_xml.toString());
        
        // TODO 应当在创建openfl项目时执行
    }

    inline function exportSound(item:DOMSoundItem)
    {
        var sound_file = Path.join(Sys.getCwd(), [document.dir, "LIBRARY", item.name]);

        if (sys.FileSystem.exists(sound_file)) {
            var tpath:Dynamic = splitClassName(item.linkageClassName);
            var sound_package_dir:Array<String> = tpath.package_name.split('.');
            sound_package_dir.insert(0, "Source");
            var sound_class_file = Path.join(target, sound_package_dir.concat([tpath.class_name + ".hx"]));

            var class_code:String = exportSoundClass(tpath.package_name, 
                tpath.class_name, item.linkageBaseClass);
            
            if (!sound_class_file.startsWith("/"))
                sound_class_file = Sys.getCwd() + sound_class_file;

            sys.io.File.saveContent(sound_class_file, class_code);
        }
    }

    inline function exportSoundClass(package_name:String, class_name:String,
        base_class_name:String):String
    {
        var class_code = 
        'package $package_name;\n' +
        '\n' +
        'import flash.media.*;\n' +
        'class $class_name';
        if (null == base_class_name || "" == base_class_name)
            base_class_name = "flash.media.Sound";
        if (null != base_class_name && "" != base_class_name)
            class_code += ' extends $base_class_name';
        class_code += '\n{\n' +
        '    public function new(?stream:URLRequest, ?context:SoundLoaderContext):Void\n' +
        '    {\n' +
        '        super(stream, context);\n' +
        '    }\n' +
        '}\n';

        return class_code;
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

        var up:String = "";
        if (~/Windows/.match(Sys.environment().get("OS")))
            up = target;
        else
            up = Path.abspath(Path.join(target_dir, ["../"]));

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

    inline function clearId(class_name:String):String
    {
        return ~/([^A-Za-z0-9_])/g.replace(class_name, "_");
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
        emptyClass("Document", "flash.display.MovieClip");

        var class_name:String = "Document";
        var base_class_name = "hx.xfl.openfl.display.MovieClip";
        // "flash.display.MovieClip";
        var document_frame_indexes = new Map<String, Array<Int>>();
        var document_frame_code = generateMainMovieClipFrameCode(
            document.getTimeLinesIterator(),
            class_name, base_class_name, document_frame_indexes);

        var document_frame_ast = CSParser.toAST(document_frame_code);
        var document_fields = document_frame_ast.typesDefd[0].fields;

        addFrameCodeIntoMovieClipConstructor(document_fields,
            document_frame_indexes, class_name);

        File.saveContent(
            Path.join(Sys.getCwd(), [target, "Source", "Document.hx"]),
            CSParser.toString(document_frame_ast)
        );

        
        for (symbol in document.getSymbolIterators()) {
            var frames:Map<String, Array<Int>> = new Map();

            var frame_code:String = generateFrameCode(symbol.timeline, frames);
            var needExport:Bool =
                symbol.linkageExportForAS || frames.keys().hasNext();

            var class_content:String = null;

            if (!symbol.linkageExportForAS && frames.keys().hasNext()) {
                class_name = clearId(symbol.name);
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

        for (class_name in process.keys()) {
            if (null != process.get(class_name) &&
                process.get(class_name) == false) {

                var file =  getClassFile(class_name);

                if (null == file)
                    continue;

                astToFile(class_name,
                    CSParser.toAST(sys.io.File.getContent(file)));
            }
        }
    }

    inline function astToFile(class_name:String, ast:Program)
    {
        var complex = splitClassName(class_name);
        var class_directory = null;
        if (complex.package_name != "")
            class_directory = complex.package_name.replace(".", "/")
        else 
            class_directory = complex.package_name;

        var haxe_class_file = Path.join(Sys.getCwd(), [target, "Source", 
            class_directory, complex.class_name + ".hx"]);

        process.set(class_name, true);

        File.saveContent(haxe_class_file, CSParser.toString(ast));
    }

    inline function exportAsSource(class_name:String, frame_code:String,
        class_content:String, frames:Map<String, Array<Int>>)
    {
        var complex = splitClassName(class_name);
        var ast:Program;
        ast = CSParser.toAST(class_content);

        var meta:Array<Expr> = ast.typesDefd[0].meta;
        
        for (i in meta) {
            switch(i) {
                case EImport(v):
                    var n = v.join(".");
                    if (process.get(n) == null)
                        process.set(n, false);
                default:
            }
        }

        for (type in ast.typesSeen) {
            switch(cast(type, T)) {
                case TPath(v):
                    var n = v.join(".");
                    if (process.get(n) == null)
                        process.set(n, false);
                default:
            }
        }

        var frame_ast = CSParser.toAST(frame_code);
        ast.typesDefd[0].fields = ast.typesDefd[0].fields.concat(
            frame_ast.typesDefd[0].fields);


        if (frames.keys().hasNext()) {
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

        process.set(class_name, true);

        File.saveContent(haxe_class_file, CSParser.toString(ast));
    }

    inline function generateFrameCode(timeline:DOMTimeLine,
        frames:Map<String, Array<Int>>)
    {
        var frame_codes:Map<Int, Array<String>> = getFrameCodes(timeline);
        var pack_frame_codes:Array<String>;

        var text_code = "package {\nclass FrameCode\n{\n";

        for (index in frame_codes.keys()) {
            var codes = frame_codes.get(index);
            if (null != codes) {
                var scene_name = clearId('');
                text_code += '\nfunction _haxecs_frame_${scene_name}_${index}()\n{\n'+
                    codes.join("\n") + "\n}\n";

                if (frames.get("") == null)
                    frames.set("", new Array<Int>());

                frames.get("").push(index);
            }
        }

        return text_code + "\n}\n}";
    }

    inline function generateMainMovieClipFrameCode(
        timelines:Iterator<DOMTimeLine>, class_name:String, 
        base_class_name:String, frames:Map<String, Array<Int>>)
    {
            

        var main_code = "package {\nclass " + class_name + " extends " + 
            base_class_name + "\n{\n" + "    public function " + class_name + 
            "()\n    {\n        super();\n    }\n";
        for (timeline in timelines) {
            var frame_codes:Map<Int, Array<String>> = getFrameCodes(timeline);
            var scene_name:String = clearId(timeline.name);

            for (index in frame_codes.keys()) {
                var codes = frame_codes.get(index);

                if (null != codes) {
                    main_code += '\nfunction _haxecs_frame_${scene_name}' + 
                        '_${index}()\n{\n' + codes.join("\n") + "\n}\n";


                    if (!frames.exists(scene_name))
                        frames.set(scene_name, new Array<Int>());
                    frames.get(scene_name).push(index);
                }
            }
        }

        return main_code + "\n}\n}";
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
        fields:Array<ClassField>, frame_indexes:Map<String, Array<Int>>,
        class_name:String)
    {
        var frames:Array<Expr> = [];
        for (index in frame_indexes)
            frames.push(EConst(CInt(Std.string(index))));

        var path_movie_clip:T = TPath(["hx", "xfl", "openfl", "display", 
            "MovieClipHelper"]);
        var new_helper_instance = EVars([
            {
                name: "helper",
                t: path_movie_clip,
                val: ENew(path_movie_clip, [EIdent("this")])
            }
        ]);

        var expressions:Array<Expr> = [];
        // expressions.push(new_helper_instance);

        for (scene in frame_indexes.keys()) {
            for (index in frame_indexes.get(scene)) {
                expressions.push(
                    ECall(EIdent("addFrame"), 
                    [
                     EConst(CInt(Std.string(index))),
                     EConst(CString(scene))]));
                expressions.push(ENL(null));
            }

        }

        for (field in fields) {
            switch (field.kind) {
            case FFun(f):
                if (field.name == class_name) {
                    switch(f.expr) {
                    case EBlock(e):
                        for (expression in expressions)
                            e.push(expression);
                    default:
                    }
                }
            default:
            }
        }
    }
}