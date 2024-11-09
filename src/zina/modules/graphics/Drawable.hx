package zina.modules.graphics;

import zina.math.Matrix4x4;
import zina.modules.graphics.GraphicsModule;

/**
 * A class that represents something that can
 * be drawn to the screen.
 */
class Drawable extends Object {
    public function getWidth():Float {
        return 0;
    }

    public function getHeight():Float {
        return 0;
    }

    public function draw(graphics:GraphicsModule, transform:Matrix4x4):Void {}
}