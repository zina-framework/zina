package zina.data;

@:structInit
class ProjectConfig {
    public var width:Int;
    public var height:Int;

    public var targetFPS:Int;
    public var vsync:Bool;

    public var sourceDir:String;
    public var mainClass:String;
    
    public var assetFolders:Array<String>;
    public var defines:Array<ProjectDefine>;

    public var exportDir:String;

    public var event:Bool;
    public var window:WindowConfig;
    public var graphics:Bool;
    public var audio:Bool;
    public var timer:Bool;
} 

typedef ProjectDefine = {
    var name:String;
    var value:String;

    var doIf:String;
    var doUnless:String;
}

typedef WindowConfig = {
    var title:String;
    var resizable:Bool;
    var borderless:Bool;
}