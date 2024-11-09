package zina._backend.macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.macro.Context;
#end

@:keep
class LibraryDocHiderMacro {
	public static macro function build():Array<Field> {
		final fields:Array<Field> = Context.getBuildFields();
		
		// TODO: this stuff, will hide all internal libraries from the user
		// to prevent them from accidentally importing them instead of
		// a Zina class of a similar name

		return fields;
	}
}
