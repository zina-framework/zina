package zina.math;

import haxe.ds.Vector;

/**
 * Basic 2-dimensional point class
 */
abstract Point(Vector<Float>) from Vector<Float> to Vector<Float> {
    public var x(get, set):Float;
    public var y(get, set):Float;

    public var magnitude(get, never):Float; // TODo: make a normalize function for the setter

    public function new(x:Float = 0, y:Float = 0) {
        this = cast [x, y];
    }

    public function distance(point:Point){
        var xDist = x - point.x;
        var yDist = y - point.y;
		return Math.sqrt(xDist * xDist + yDist * yDist);
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    @:noCompletion
    private inline function get_x():Float {
        return this[0];
    }

    @:noCompletion
    private inline function get_y():Float {
        return this[1];
    }

    @:noCompletion
    private inline function get_magnitude():Float {
        return Math.sqrt(x*x+y*y);
    }

    @:noCompletion
    private inline function set_x(newX:Float):Float {
        return this[0] = newX;
    }

    @:noCompletion
    private inline function set_y(newY:Float):Float {
        return this[1] = newY;
    }
}