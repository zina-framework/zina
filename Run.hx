import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.Json;
import haxe.io.Path;
import haxe.macro.*;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import zina._backend.utils.FileUtil;
import zina._backend.macros.ProjectMacro;
import zina.data.ProjectConfig;

#if macro
using haxe.macro.PositionTools;
#end
using StringTools;

class Run {
	public static function main():Void {
		final args:Array<String> = Sys.args().copy();
		args.resize(args.length - 1);

		if (args != null && args.length != 0) {
			for (i in 0...args.length) {
				var arg:String = args[i];
				if (arg != null && arg.startsWith("--"))
					arg = arg.substr(1);

				switch (arg) {
					case null:
						// No arguments to see here!
						break;

					case "h", "help":
						helpCmd();

					case "a", "about":
						aboutCmd();

                    case "c", "create":
                        createCmd();

					case "e", "export":
						exportCmd();
						Sys.exit(0);

					case "t", "test":
						final result:Bool = exportCmd();
						if(result)
							runCmd();

					case "r", "run":
						runCmd();

					default:
						Sys.println('[ Oops! That command doesn\'t exist!  ]');
						Sys.println('[ Here\'s a list of commands to help:  ]\n');
						helpCmd();
				}
			}
		} else {
			Sys.println('[ Oops! You need to specify a command! ]');
			Sys.println('[ Here\'s a list of commands to help:   ]\n');
			helpCmd();
		}
	}

	public static function helpCmd():Void {
		Sys.println('[ zina.hx - Command Line Help ------------- ]');
		Sys.println('[ help    - Outputs this help message.      ]');
		Sys.println('[ about   - Learn some info about Zina.     ]');
		Sys.println('[ create  - Create an empty sample project. ]');
		Sys.println('[ export  - Export a Zina project.          ]');
		Sys.println('[ run     - Runs a Zina project.            ]');
		Sys.println('[ test    - Test a Zina project.            ]');
		Sys.println('[ ----------------------------------------- ]');
		Sys.exit(0);
	}

	public static function aboutCmd():Void {
		final haxelibJson:Dynamic = Json.parse(File.getContent(RunMacro.getHaxelibJsonPath()));

		Sys.println('[ zina.hx - About Zina ------------------------------ ]');

		var versionStr:String = Std.string(haxelibJson.version);

		var commitHash:String = RunMacro.getCommitHash();
		if (commitHash != "-")
			versionStr += '@${commitHash}';

		Sys.println('[ Version - Currently running v${versionStr.rpad(" ", 22)} ]');
		Sys.println('[ --------------------------------------------------- ]');

		Sys.println('[ Zina aims to be a simple framework providing devs-  ]');
		Sys.println('[ with a simple, yet flexible API for both graphics & ]');
		Sys.println('[ audio for easy game development.                    ]');

		Sys.println('[ --------------------------------------------------- ]');
		Sys.exit(0);
	}

	public static function createCmd():Void {
		final args:Array<String> = Sys.args().copy();
		final curDir:String = args[args.length - 1];

		Sys.println('[ Please input a project name ---------------- ]');
		final projectName:String = Sys.stdin().readLine();
        
		Sys.println('[ Are you sure you\'re in the right directory? ]');
		Sys.println('[ ${curDir.rpad(" ", 43)} ]');
		final answer:String = Sys.stdin().readLine();
        switch(answer.toLowerCase()) {
            case "y", "yes", "true", "correct", "mhm", "sure", "yeah", "yep":
                // Do nothing, just continue on!

            default:
                // Stop right there!!!
                Sys.exit(0);
        }
		try {
            final newDir:String = Path.normalize(Path.join([curDir, projectName]));
            final emptyZipFile:String = Path.normalize(Path.join([RunMacro.getZinaHaxelibDir(), "samples", "empty.zip"]));

            if (FileSystem.exists(newDir)) {
                Sys.println('Project at ${newDir} already exists! Please delete it before continuing.');
                return;
            } else {
                Sys.println('Creating project at ${newDir}...');
                FileSystem.createDirectory(newDir);
                FileUtil.unzipFile(emptyZipFile, newDir);
            }
            Sys.println('Project at ${newDir} has been created!');
        } catch (e) {
            Sys.println('Oops: ${e}');
        }
		Sys.exit(0);
	}

	public static function exportCmd():Bool {
		final libDir:String = Sys.getCwd();
		final sysArgs:Array<String> = Sys.args().copy();
		
		final curDir:String = sysArgs[sysArgs.length - 1];
		Sys.setCwd(curDir);

		final cfg:ProjectConfig = ProjectMacro.getConfigUnsafe(Path.normalize(Path.join([curDir, "conf.hx"])));
		final args:Array<String> = [];

		args.push('--class-path ${cfg.sourceDir}');

		args.push('--library zina');
		for(lib in cfg.libraries)
			args.push('--library ${lib.name}${(lib.version != null && lib.version.length != 0) ? ':${lib.version}' : ""}');

		final platform:String = Sys.systemName().toLowerCase();
		args.push('--cpp ${cfg.exportDir}/${platform}/obj');
		
		final isDebug:Bool = sysArgs.contains("-debug") || sysArgs.contains("--debug");
		if(isDebug) {
			cfg.isDebugBuild = true;
			args.push("--debug");
		}
		if(cfg.exportAs32Bit)
			args.push("--define HXCPP_M32");
		else
			args.push("--define HXCPP_M64");

		final defs:Map<String, String> = RunMacro.getDefines();
		defs.set("windows", (Sys.systemName() == "Windows") ? "1" : "0");
		defs.set("linux", (Sys.systemName() == "Linux") ? "1" : "0");
		defs.set("bsd", (Sys.systemName() == "BSD") ? "1" : "0");
		defs.set("mac", (Sys.systemName() == "Mac") ? "1" : "0");
		defs.set("macos", (Sys.systemName() == "Mac") ? "1" : "0");

		final desktopSystems:Array<String> = [defs.get("windows"), defs.get("linux"), defs.get("mac")];
		defs.set("desktop", desktopSystems.contains("1") ? "1" : "0");
		
		for(def in cfg.defines)
			defs.set(def.name, (def.value != null && def.value.length != 0) ? def.value : "1");
		
		for(def in cfg.defines) {
			function resolveStringIf(defines:Map<String, String>, condition:String, checkParenthCount:Bool):Bool {
				if (checkParenthCount && condition.contains("(")) {
					var leftCount:Int = 0;
					var rightCount:Int = 0;
					var countIndex:Int = -1;
					while ((countIndex = condition.indexOf("(", countIndex)) >= 0)
						leftCount++;
	
					countIndex = -1;
					while ((countIndex = condition.indexOf(")", countIndex)) >= 0) // please tell me theres a better way of counting these strings
						rightCount++;
	
					if (leftCount != rightCount)
						throw 'Unable to parse condition "${condition}": Unmatched parenthesis count. $leftCount "(" | $rightCount ")")';
				}
	
				if (condition.contains("||")) {
					var toReturn:Bool = false;
					for (split in condition.split("||"))
						toReturn = toReturn || resolveStringIf(defines, split.trim(), false);
					return toReturn;
				}
				if (condition.contains("&&")) {
					for (split in condition.split("&&")) {
						if (!resolveStringIf(defines, split.trim(), false))
							return false;
					}
					return true;
				}
				return (defines[condition] == null || defines[condition] == "0" || defines[condition] == "false");
			}
			var canPushDefine:Bool = true;
			if(def.doIf != null && def.doIf.length != 0)
				canPushDefine = resolveStringIf(defs, def.doIf, true);
			
			if(def.doUnless != null && def.doUnless.length != 0)
				canPushDefine = canPushDefine && !resolveStringIf(defs, def.doUnless, true);

			if(canPushDefine)
				args.push('--define ${def.name}${(def.value != null && def.value.length != 0) ? '=${def.value}' : ""}');
		}

		args.push('--main ${cfg.mainClass}');

		Sys.setCwd(curDir);

		final binFolder:String = Path.normalize(Path.join([curDir, cfg.exportDir, platform, "bin"]));
		if(!FileSystem.exists(binFolder))
			FileSystem.createDirectory(binFolder);

		final compileError:Int = Sys.command('haxe ${args.join(" ")}');
		if(compileError == 0) {
			Sys.setCwd(Path.normalize(Path.join([curDir, cfg.exportDir, platform, "obj"])));
			
			if(Sys.systemName() == "Windows") { // Windows
				final exePath:String = Path.normalize(Path.join([binFolder, '${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}${((cfg.isDebugBuild) ? "-debug" : "")}.exe']));
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.mainClass.substring(cfg.mainClass.lastIndexOf(".") + 1)}${((cfg.isDebugBuild) ? "-debug" : "")}.exe'])),
					exePath
				);
				for(file in FileSystem.readDirectory(Sys.getCwd())) {
					if(Path.extension(file) == "dll") {
						File.copy(
							Path.normalize(Path.join([Sys.getCwd(), file])),
							Path.normalize(Path.join([binFolder, file]))
						);
					}
				}
				if(cfg.window.icon != null && cfg.window.icon.length != 0) {
					final projIconDir:String = Path.normalize(Path.join([curDir, cfg.window.icon]));
					final outputIconDir:String = Path.normalize(Path.join([binFolder, "icon.ico"]));
					
					if(FileSystem.exists(projIconDir)) {
						// Generate ico file
						Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows", "magick"])));
						Sys.command("convert.exe", ["-resize", "256x256", projIconDir, outputIconDir]);
						
						// Apply icon to exe file
						Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows"])));
						Sys.command("ReplaceVistaIcon.exe", [exePath, outputIconDir]);
					} else
						Sys.println('Icon file "${cfg.window.icon}" doesn\'t exist in the project directory!.');
				}
			} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.mainClass.substring(cfg.mainClass.lastIndexOf(".") + 1)}${((cfg.isDebugBuild) ? "-debug" : "")}'])),
					Path.normalize(Path.join([binFolder, '${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}${((cfg.isDebugBuild) ? "-debug" : "")}']))
				);
				Sys.setCwd(binFolder);
				Sys.command('chmod +x "${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}${((cfg.isDebugBuild) ? "-debug" : "")}"');
			}
		}
		return compileError == 0;
	}

	public static function runCmd():Void {
		final sysArgs:Array<String> = Sys.args().copy();
		final isDebug:Bool = sysArgs != null && (sysArgs.contains("-debug") && sysArgs.contains("--debug"));

		final curDir:String = sysArgs[sysArgs.length - 1];
		Sys.setCwd(curDir);

		final cfg:ProjectConfig = ProjectMacro.getConfigUnsafe(Path.normalize(Path.join([curDir, "conf.hx"])), isDebug);
		final platform:String = Sys.systemName().toLowerCase();
		
		if(platform == "windows") { // Windows
			final execDir:String = Path.normalize(Path.join([curDir, cfg.exportDir, platform, "bin"]));
			if(FileSystem.exists(execDir)) {
				Sys.setCwd(execDir);

				final execPath:String = '${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}.exe';
				final execDebugPath:String = '${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}-debug.exe';
				
				if(cfg.isDebugBuild)
					Sys.command('"${execDebugPath}"');
				else
					Sys.command('"${execPath}"');
			} else
				Sys.println('You haven\'t exported to ${(isDebug) ? "debug" : "release"} yet!');
			
		} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
			final execDir:String = Path.normalize(Path.join([curDir, cfg.exportDir, platform, "bin"]));
			if(FileSystem.exists(execDir)) {
				Sys.setCwd(execDir);

				final execPath:String = './${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}';
				final execDebugPath:String = './${cfg.executableName ?? cfg.mainClass.substr(cfg.mainClass.lastIndexOf(".") + 1)}-debug';
				
				if(cfg.isDebugBuild)
					Sys.command('"${execDebugPath}"');
				else
					Sys.command('"${execPath}"');
			} else
				Sys.println('You haven\'t exported to ${(isDebug) ? "debug" : "release"} yet!');
		}
		Sys.exit(0);
	}
}

class RunMacro {
	public static macro function getDefines() {
		#if macro
		return macro $v{Context.getDefines()};
		#else
		return macro $v{null};
		#end
	}

	public static macro function getZinaHaxelibDir() {
		#if macro
		final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		var sourcePath:String = Path.directory(posInfo.file);
		if (!Path.isAbsolute(sourcePath))
			sourcePath = Path.join([Sys.getCwd(), sourcePath]);

		sourcePath = Path.normalize(sourcePath);
		return macro $v{sourcePath};
		#else
		return macro $v{null};
		#end
	}

	public static macro function getHaxelibJsonPath() {
		#if macro
		final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		var sourcePath:String = Path.directory(posInfo.file);
		if (!Path.isAbsolute(sourcePath))
			sourcePath = Path.join([Sys.getCwd(), sourcePath]);

		sourcePath = Path.normalize(sourcePath);

		final jsonPath:String = Path.normalize(Path.join([sourcePath, "haxelib.json"]));
		return macro $v{jsonPath};
		#else
		return macro $v{null};
		#end
	}

	public static macro function getCommitHash() {
		#if macro
		try {
			var proc = new Process('git', ['rev-parse', '--short', 'HEAD'], false);
			proc.exitCode(true);
			return macro $v{proc.stdout.readLine()};
		} catch (e) {
			// Do nothing <3
		}
		return macro $v{"-"};
		#else
		return macro $v{"-"};
		#end
	}
}
