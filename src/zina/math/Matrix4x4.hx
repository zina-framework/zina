package zina.math;

import cpp.Pointer;
import haxe.ds.Vector;

// TODO: clean this code up holy shit

/**
 * srt's little safe space :3
 * just a reference for the value positions
 * [0, 1, 2, 3]
 * [4, 5, 6, 7]
 * [8, 9, 10, 11]
 * [12, 13, 14, 15]
 */

/**
 * Three-dimensional, four-by-four matrix.
 * 
 * @author swordcube, srtpro278, lavenderdev, Nebula_Zorua
 */
@:forward
abstract Matrix4x4(Vector<Float>) from Vector<Float> to Vector<Float> {
    /**
     * Constructs a new `Matrix4x4`.
     */
    public function new():Void {
        this = new Vector<Float>(16, 0.0);
        identity();
    }
    
    @:op([])
    public function get(i:Int):Float {
        return this[i];
    }

    @:op([])
    public function set(i:Int, val:Float):Float {
        return this[i] = val;
    }

    @:to
    public function toPointer():Pointer<Matrix4x4> {
        return Pointer.ofArray(cast this);
    }

    public function copyFrom(mat:Matrix4x4):Matrix4x4 {
        for(i in 0...this.length) {
            this[i] = mat[i];
        }
        return this;
    }
    
    /**
     * @param  x  Value to increase the X axis.
     * @param  y  Value to increase the Y axis.
     * @param  z  Value to increase the Z axis.
     */
    public function translate(x:Float, y:Float, z:Float):Void {
        this[3] += x; 
        this[7] += y;
        this[11] += z;
    }
    
    /**
     * @param  x  Value for scaling the X axis.
     * @param  y  Value for scaling the Y axis.
     * @param  z  Value for scaling the Z axis.
     */
    public function scale(x:Float, y:Float, z:Float):Void {
        for (i in 0...4) {
            this[i] *= x;
            this[i + 4] *= y;
            this[i + 8] *= z;
        }
    }

    // actually a 3d rotation func from blueprint but simplified
    public function rotateZ(radians:Float):Void {
        var sin = Math.sin(radians);
        var cos = Math.cos(radians);
        
        _cacheMatrix.setNum(0, 0, cos);
        _cacheMatrix.setNum(0, 1, -sin);
        _cacheMatrix.setNum(0, 2, 0.0);

        _cacheMatrix.setNum(1, 0, sin);
        _cacheMatrix.setNum(1, 1, cos);
        _cacheMatrix.setNum(1, 2, 1.0 - cos);

        _cacheMatrix.setNum(2, 0, 0.0);
        _cacheMatrix.setNum(2, 1, 0.0);
        _cacheMatrix.setNum(2, 2, cos + (1.0 - cos));
        
        _cacheMatrix.setRow(0, 
            (getNum(0, 0) * _cacheMatrix.getNum(0, 0) + getNum(1, 0) * _cacheMatrix.getNum(0, 1) + getNum(2, 0) * _cacheMatrix.getNum(0, 2)),
			(getNum(0, 1) * _cacheMatrix.getNum(0, 0) + getNum(1, 1) * _cacheMatrix.getNum(0, 1) + getNum(2, 1) * _cacheMatrix.getNum(0, 2)),
			(getNum(0, 2) * _cacheMatrix.getNum(0, 0) + getNum(1, 2) * _cacheMatrix.getNum(0, 1) + getNum(2, 2) * _cacheMatrix.getNum(0, 2)),
			(getNum(0, 2) * _cacheMatrix.getNum(0, 0) + getNum(1, 3) * _cacheMatrix.getNum(0, 1) + getNum(2, 3) * _cacheMatrix.getNum(0, 2))
        );

        _cacheMatrix.setRow(1, 
            (getNum(0, 0) * _cacheMatrix.getNum(1, 0) + getNum(1, 0) * _cacheMatrix.getNum(1, 1) + getNum(2, 0) * _cacheMatrix.getNum(1, 2)),
			(getNum(0, 1) * _cacheMatrix.getNum(1, 0) + getNum(1, 1) * _cacheMatrix.getNum(1, 1) + getNum(2, 1) * _cacheMatrix.getNum(1, 2)),
			(getNum(0, 2) * _cacheMatrix.getNum(1, 0) + getNum(1, 2) * _cacheMatrix.getNum(1, 1) + getNum(2, 2) * _cacheMatrix.getNum(1, 2)),
			(getNum(0, 2) * _cacheMatrix.getNum(1, 0) + getNum(1, 3) * _cacheMatrix.getNum(1, 1) + getNum(2, 3) * _cacheMatrix.getNum(1, 2))
        );
        
        // would be adding the mult of [2][0] and [2][1] but those are 0
        _cacheMatrix.setRow(2, 
            (getNum(2, 0) * _cacheMatrix.getNum(2, 2)),
			(getNum(2, 1) * _cacheMatrix.getNum(2, 2)),
			(getNum(2, 2) * _cacheMatrix.getNum(2, 2)),
			(getNum(2, 3) * _cacheMatrix.getNum(2, 2))
        );

        for (i in 0...12)
            this[i] = _cacheMatrix[i];
    }

    /**
     * Sets diagonal elements of the matrix to 1 and the rest to 0    
     */
	public inline function identity():Matrix4x4 {
        for (i in 0...this.length) {
            this[i] = (i % 5 == 0) ? 1.0 : 0.0;
        }
        return this;
    }


    // I hope these work! -neb
    // They should work, in theory -neb

    @:op(A * B)
    public function mul(val:Matrix4x4) {
        
        var newMat:Matrix4x4 = new Vector<Float>(this.length, 0.0);

        for(i in 0...4){
            var index0 = getNum(0, i);
            var index1 = getNum(1, i);
            var index2 = getNum(2, i);
            var index3 = getNum(3, i);

			newMat.setNum(0, i, (index0 * val.getNum(i, 0)) + (index0 * val.getNum(i, 1)) + (index0 * val.getNum(i, 2)) + (index0 * val.getNum(i, 3)));
            newMat.setNum(1, i, (index1 * val.getNum(i, 0)) + (index1 * val.getNum(i, 1)) + (index1 * val.getNum(i, 2)) + (index1 * val.getNum(i, 3)));
            newMat.setNum(2, i, (index2 * val.getNum(i, 0)) + (index2 * val.getNum(i, 1)) + (index2 * val.getNum(i, 2)) + (index2 * val.getNum(i, 3)));
            newMat.setNum(3, i, (index3 * val.getNum(i, 0)) + (index3 * val.getNum(i, 1)) + (index3 * val.getNum(i, 2)) + (index3 * val.getNum(i, 3)));
        }
		
        return newMat;
    }
    
    
    @:op(A *= B)
    public function mulEQ(val:Matrix4x4) {
        for(i in 0...4){
            var index0 = getNum(0, i);
            var index1 = getNum(1, i);
            var index2 = getNum(2, i);
            var index3 = getNum(3, i);

			setNum(0, i, (index0 * val.getNum(i, 0)) + (index0 * val.getNum(i, 1)) + (index0 * val.getNum(i, 2)) + (index0 * val.getNum(i, 3)));
            setNum(1, i, (index1 * val.getNum(i, 0)) + (index1 * val.getNum(i, 1)) + (index1 * val.getNum(i, 2)) + (index1 * val.getNum(i, 3)));
            setNum(2, i, (index2 * val.getNum(i, 0)) + (index2 * val.getNum(i, 1)) + (index2 * val.getNum(i, 2)) + (index2 * val.getNum(i, 3)));
            setNum(3, i, (index3 * val.getNum(i, 0)) + (index3 * val.getNum(i, 1)) + (index3 * val.getNum(i, 2)) + (index3 * val.getNum(i, 3)));
        }
		
        return this;
    }
    /**
     * A more readable variation of getting a number.
     * @param row The row of the requested location.
     * @param column The column of the requested location.
     * @return Float - The value of the requested location.
     */
    public inline function getNum(row:Int, column:Int):Float {
        return this[row + column * 4];
    }

    /**
     * A more readable variation of setting a number.
     * @param row The row of the requested location.
     * @param column The column of the requested location.
     * @param num The new value of the requested location.
     * @return `num`. (The new value of the requested location)
     */
    public inline function setNum(row:Int, column:Int, num:Float):Float {
        return this[row + column * 4] = num;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //
    
    // dont set this to inline. it may mess with the setting.
    private function setRow(row:Int, x:Float, y:Float, z:Float, w:Float) {
        var rowIdx = 4 * row;
        this[rowIdx] = x;
        this[rowIdx + 1] = y;
        this[rowIdx + 2] = z;
        this[rowIdx + 3] = w;
    }
    
    private static var _cacheMatrix:Matrix4x4 = new Matrix4x4();
}
