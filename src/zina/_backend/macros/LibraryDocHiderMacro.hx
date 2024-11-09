package zina._backend.macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.macro.Context;
#end

@:keep
class LibraryDocHiderMacro {
	public static macro function build():Array<Field> {
		final fields:Array<Field> = Context.getBuildFields().copy();
		for(field in fields) {
			trace(field.name);
		}
		return fields;
	}
}
