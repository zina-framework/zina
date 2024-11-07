import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.Json;
import haxe.io.Path;
import haxe.macro.*;
import zina._backend.utils.FileUtil;

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
}

class RunMacro {
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
