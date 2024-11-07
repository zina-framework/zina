package zina._backend.macros;


import sys.io.File;
import sys.FileSystem;

import haxe.io.Path;

#if macro
import haxe.macro.*;
import haxe.macro.Expr;
#end
#if (macro || !eval)
import zina.Zina;
import zina.core.App;
import zina.data.ProjectConfig;
#end

import hscript.Interp as HScriptInterp;
import hscript.Parser as HScriptParser;
import hscript.Expr as HScriptExpr;

#if macro
using haxe.macro.PositionTools;
#end
using StringTools;

@:keep
class AppMacro {
	public static macro function build():Array<Field> {
        #if macro
        final fields = Context.getBuildFields();

        // Get project config file
        final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		final sourcePath:String = Path.normalize(Sys.getCwd());
		final cfgPath:String = Path.normalize(Path.join([sourcePath, "conf.hx"]));
        
        if (!FileSystem.exists(cfgPath))
			Context.fatalError('Couldn\'t find a valid "conf.hx" file! ' + cfgPath, Context.currentPos());

		final sysArgs:Array<String> = Sys.args().copy();
		final cfgScript:String = File.getContent(cfgPath).replace("\r", "");

		final parser:HScriptParser = new HScriptParser();
		final cfgScript:HScriptExpr = parser.parseString(File.getContent(cfgPath), cfgPath);

		final interp:HScriptInterp = new HScriptInterp();
		interp.execute(cfgScript);

		final func:ProjectConfig->Void = interp.variables.get("configure");
		if (func == null)
			Context.fatalError('Couldn\'t find a "configure" function in conf.hx!', pos);

		final cfg:ProjectConfig = {
			targetFPS: 0,
			vsync: false,

			sourceDir: "src",
			mainClass: "Main",

			assetFolders: [], // TODO: make these actually work

			libraries: [],
			defines: [],

			exportAs32Bit: false,
			exportDir: "export",

			isDebugBuild: #if debug true #else sysArgs != null && (sysArgs.contains("-debug") || sysArgs.contains("--debug")) #end,
			executableName: null,

            event: true,
            window: {
				title: "zina.hx",
				icon: null,

                width: 640,
                height: 480,

                resizable: true,
                borderless: false
            },
			graphics: true,
			audio: true,
			timer: true
		};
		func(cfg);
        
        // The actual macro
        var mainExpr = macro {
            final app:App = Type.createInstance(Type.resolveClass($v{cfg.mainClass}), []);
            Zina.begin();
        };

        var func:Function = {
            ret: TPath({name: "Void", params: [], pack: []}),
            params: [],
            expr: mainExpr,
            args: []
        };

        var mainField:Field = {
            name: "main",
            access: [AStatic],
            kind: FFun(func),
            pos: Context.currentPos(),
            doc: null,
            meta: []
        };
        fields.push(mainField);
        
        return fields;
        #else
        return [];
        #end
    }
}