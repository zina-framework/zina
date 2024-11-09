package zina.modules.graphics;

import zina.utils.Color;

class VertexData {
    // position
    public var x:Float;
    public var y:Float;
    // color
    public var tint:Color;
    // data
    public var vertices:Array<Float>;
    public var uvs:Array<Float>;
    public var indices:Array<Int>;
    // functions
    public function new(x:Float, y:Float, color:Color, vertices:Array<Float>, uvs:Array<Float>, indices:Array<Int>) {
        this.x = x;
        this.y = y;
        this.tint = color;
        this.vertices = vertices;
        this.uvs = uvs;
        this.indices = indices;
    }
    // probly double check this
    inline function getOffsetX() {
        return 0;
    }

    inline function getOffsetY() {
        return 8;
    }

    inline function getOffsetTint() {
        return 16;
    }

    inline function getOffsetVertices() {
        return 48;
    }

    function getOffsetUvs() {
        return 48 + 8*this.vertices.length;
    }

    function getOffsetIndices() {
        return 48 + 8*this.vertices.length + 8*this.uvs.length;
    }
    function getStride() {
        return 48 + 8*this.vertices.length + 8*this.uvs.length + 4*this.indices.length;
    }

}