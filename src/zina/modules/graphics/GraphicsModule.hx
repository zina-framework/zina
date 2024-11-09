package zina.modules.graphics;

import sdl.SDL;
import sdl.Types;

import glad.Glad;

import zina.utils.Color;
import zina.math.Matrix4x4;

import zina.objects.*;
import zina.modules.image.Image;
import zina.modules.window.WindowModule;

using StringTools;

/**
 * The module responsible for controlling graphics related things.
 */
@:access(zina.modules.window.WindowModule)
class GraphicsModule {
    /**
     * Constructs a new `GraphicsModule`.
     */
    public function new() {
        _transformStack.reserve(16);
        _transformStack.pushBack(new Matrix4x4());
    }

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

    public function getTransform():Matrix4x4 {
        return _transformStack.back();
    }

	public function origin():Void {
		_transformStack.back().identity();
	}

    public function push():Void {
        if(_transformStack.data.length == _transformStack.reserved)
            throw "Maximum stack depth reached (more pushes than pops?)";

        _transformStack.pushBack(new Matrix4x4().copyFrom(_transformStack.back()));
    }

    public function pop():Void {
        if(_transformStack.data.length < 1)
            throw "Minimum stack depth reached (more pops than pushes?)";

        _transformStack.popBack();
    }
	
	public function translate(x:Float, y:Float):Void {
		_transformStack.back().translate(x, y, 0);
	}

	public function scale(x:Float, y:Float):Void {
		_transformStack.back().scale(x, y, 1);
	}

	public function rotate(radians:Float):Void {
		_transformStack.back().rotateZ(radians);
	}

    public overload extern inline function draw(drawable:Drawable, x:Float = 0, y:Float = 0, rotation:Float = 0, scaleX:Float = 1, scaleY:Float = 1, originX:Float = 0, originY:Float = 0):Void {
        final transform:Matrix4x4 = _prepareTransform(drawable, x, y, rotation, scaleX, scaleY, originX, originY);
        _transformStack.pushBack(transform);
        
        drawable.draw(this, transform);
        _transformStack.popBack();
    }

    public overload extern inline function draw(image:Image, x:Float = 0, y:Float = 0, rotation:Float = 0, scaleX:Float = 1, scaleY:Float = 1, originX:Float = 0, originY:Float = 0):Void {
        final transform:Matrix4x4 = _prepareTransform(image, x, y, rotation, scaleX, scaleY, originX, originY);
        _transformStack.pushBack(transform);
        
        image.draw(this, transform);
        _transformStack.popBack();
    }
	
    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _bgColor:Color = Color.BLACK;
    private var _transformStack:TransformStack = new TransformStack();

    private inline function _prepareTransform(drawable:Drawable, x:Float = 0, y:Float = 0, rotation:Float = 0, scaleX:Float = 1, scaleY:Float = 1, originX:Float = 0, originY:Float = 0):Matrix4x4 {
        final transform:Matrix4x4 = new Matrix4x4().copyFrom(_transformStack.back());
        transform.translate(x, y, 0);

        final w2:Float = drawable.getWidth() * originX;
        final h2:Float = drawable.getHeight() * originY;
        transform.scale(scaleX, scaleY, 1);
        
        transform.translate(w2, h2, 0);
        transform.rotateZ(rotation);
        transform.translate(-w2, -h2, 0);

        return transform;
    }
}