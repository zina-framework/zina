package zina.modules.graphics;

import zina.math.Matrix4x4;

@:forward
enum abstract TransformStack(TransformStackImpl) from TransformStackImpl to TransformStackImpl {
    public function new() {
        this = new TransformStackImpl();
    }

    public inline function pushBack(transform:Matrix4x4):Void {
        this.data.push(transform);
    }

    public inline function pushFront(transform:Matrix4x4):Void {
        this.data.insert(0, transform);
    }

    public inline function popBack():Void {
        this.data.resize(this.data.length - 1);
    }

    public inline function popFront():Void {
        this.data.splice(1, 0);
    }

    public inline function back():Matrix4x4 {
        return this.data.back();
    }

    public inline function front():Matrix4x4 {
        return this.data.front();
    }
}

private class TransformStackImpl {
    public var data:Array<Matrix4x4> = [];
    public var reserved(default, null):Int = 0;

    public function new() {
        data = [];
    }

    public inline function reserve(amount:Int):Void {
        reserved = amount;
    }
}