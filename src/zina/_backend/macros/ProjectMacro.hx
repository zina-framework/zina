package zina._backend.macros;

#if macro
import haxe.macro.*;
#end
import sys.io.File;
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
import zina.data.ProjectConfig;

@:keep
class ProjectMacro {
	public static macro function getConfig(?cfgPath:String) {
		#if macro
		if (cfgPath == null || cfgPath.length == 0)
			cfgPath = Path.normalize(Path.join([Sys.getCwd(), "conf.hx"]));

		if (!FileSystem.exists(cfgPath))
			Context.fatalError('Couldn\'t find a valid "conf.hx" file! ' + cfgPath, Context.currentPos());

		final cfgScript:String = File.getContent(cfgPath).replace("\r", "");

		final parser:HScriptParser = new HScriptParser();
		final cfgScript:HScriptExpr = parser.parseString(File.getContent(cfgPath), cfgPath);

		final interp:HScriptInterp = new HScriptInterp();
		interp.execute(cfgScript);

		final func:ProjectConfig->Void = interp.variables.get("configure");
		if (func == null)
			Context.fatalError('Couldn\'t find a "configure" function in conf.hx!', pos);

		final cfg:ProjectConfig = {
			width: 640,
			height: 480,

			targetFPS: 0,
			vsync: false,

			sourceDir: "src",
			mainClass: "Main",

			assetFolders: [], // TODO: make these actually work
			defines: [], // TODO: make these actually work

			exportDir: "export",

            event: true,
            window: {
				title: "zina.hx",
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
}
