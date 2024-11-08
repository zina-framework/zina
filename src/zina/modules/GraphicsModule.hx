package zina.modules;

import sdl.SDL;
import sdl.Types;

import glad.Glad;

import zina.utils.Color;
import zina.math.Matrix4x4;

using StringTools;

/**
 * The module responsible for controlling graphics related things.
 */
@:access(zina.modules.WindowModule)
class GraphicsModule {
    /**
     * Constructs a new `GraphicsModule`.
     */
    public function new() {}

    /**
     * Clears the screen and sets it to the specified color.
     * 
     * @param  color  The color to set the screen to.
     */
    public function clear(color:Color):Void {
		Glad.clearColor(color.r, color.g, color.b, color.a);
        Glad.clear(Glad.COLOR_BUFFER_BIT);
    }

    /**
     * Presents everything that was drawn to the screen.
     */
    public function present():Void {
        final window:WindowModule = Zina.window;
        SDL.glSwapWindow(window._window);
    }

    /**
     * Returns the current background color.
     */
    public function getBackgroundColor():Color {
        return _bgColor;
    }

    /**
     * Sets the background color to a specified color.
     * 
     * @param  color  The new background color. (defaults to black)
     */
    public function setBackgroundColor(?color:Color):Void {
		if(color == null)
			color = Color.BLACK;

        _bgColor.copyFrom(color);
    }

	public function origin():Void {
		_transformMatrix.identity();
	}
	
	public function translate(x:Float, y:Float):Void {
		_transformMatrix.translate(x, y, 0);
	}

	public function scale(x:Float, y:Float):Void {
		_transformMatrix.scale(x, y, 1);
	}

	public function rotate(radians:Float):Void {
		_transformMatrix.rotateZ(radians);
	}
	
    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _bgColor:Color = Color.BLACK;
	private var _transformMatrix:Matrix4x4 = new Matrix4x4();
}