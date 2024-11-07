package zina._backend.macros;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import hscript.Parser as HScriptParser;
import hscript.Interp as HScriptInterp;
import hscript.Expr as HScriptExpr;
import zina.data.ProjectConfig;
#if macro
import haxe.macro.*;
import haxe.macro.ExprTools;
#end

using StringTools;

@:keep
class ProjectMacro {
	public static macro function getConfig(?cfgPath:Expr.ExprOf<String>) {
		#if macro
		final pos = Context.currentPos();
		
		var cfgPath:String = ExprTools.getValue(cfgPath);
		if (cfgPath == null || cfgPath.length == 0)
			cfgPath = Path.normalize(Path.join([Sys.getCwd(), "conf.hx"]));

		if (!FileSystem.exists(cfgPath))
			Context.fatalError('Couldn\'t find a valid "conf.hx" file! ' + cfgPath, pos);

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
			defines: [], // TODO: make these actually work

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
		return macro $v{cfg};
		#else
		return macro $v{null};
		#end
	}

	public static function getConfigUnsafe(?cfgPath:String, ?forceDebug:Bool = false) {
		if (cfgPath == null || cfgPath.length == 0)
			cfgPath = Path.normalize(Path.join([Sys.getCwd(), "conf.hx"]));
		
		final sysArgs:Array<String> = Sys.args().copy();
		final cfgScript:String = File.getContent(cfgPath).replace("\r", "");

		final parser:HScriptParser = new HScriptParser();
		final cfgScript:HScriptExpr = parser.parseString(File.getContent(cfgPath), cfgPath);

		final interp:HScriptInterp = new HScriptInterp();
		interp.execute(cfgScript);

		final func:ProjectConfig->Void = interp.variables.get("configure");
		if (func == null) {
			Sys.println('Couldn\'t find a "configure" function in conf.hx!');
			Sys.exit(1);
		}
		final cfg:ProjectConfig = {
			targetFPS: 0,
			vsync: false,

			sourceDir: "src",
			mainClass: "Main",

			assetFolders: [], // TODO: make these actually work

			libraries: [],
			defines: [], // TODO: make these actually work

			exportAs32Bit: false,
			exportDir: "export",

			isDebugBuild: (forceDebug) ? true : #if debug true #else sysArgs != null && (sysArgs.contains("-debug") || sysArgs.contains("--debug")) #end,
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
		return cfg;
	}
}
