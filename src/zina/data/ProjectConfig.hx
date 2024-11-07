package zina.data;

typedef ProjectConfig = {
    var targetFPS:Int;
    var vsync:Bool;

    var sourceDir:String;
    var mainClass:String;
    
    var assetFolders:Array<ProjectAssetFolder>;

    var libraries:Array<ProjectLibrary>;
    var defines:Array<ProjectDefine>;

    var exportAs32Bit:Bool;
    var exportDir:String;

    var isDebugBuild:Bool;
    var ?executableName:String;

    var event:Bool;
    var window:WindowConfig;
    var graphics:Bool;
    var audio:Bool;
    var timer:Bool;
} 

typedef ProjectAssetFolder = {
    var name:String;
    var ?embed:Bool;
}

typedef ProjectDefine = {
    var name:String;
    var value:String;

    var ?doIf:String;
    var ?doUnless:String;
}

typedef ProjectLibrary = {
    var name:String;
    var ?version:String;
}

typedef WindowConfig = {
    var title:String;
    var icon:String;

    var width:Int;
    var height:Int;

    var resizable:Bool;
    var borderless:Bool;
}