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
        
        final cfg:ProjectConfig = ProjectMacro.getConfig(cfgPath);
        
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