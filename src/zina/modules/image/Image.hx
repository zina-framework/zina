package zina.modules.image;

import zina.math.Matrix4x4;

import zina.modules.graphics.Drawable;
import zina.modules.graphics.GraphicsModule;

/**
 * A class that represents a image.
 */
class Image extends Drawable {
    private function new() {
        super();
    }

    override function getWidth():Int {
        return _data.getWidth();
    }

    override function getHeight():Int {
        return _data.getHeight();
    }

    public function getData():ImageData {
        return _data;
    }

    public function getChannels():Int {
        return _data.getChannels();
    }

    override function draw(graphics:GraphicsModule, transform:Matrix4x4):Void {}
    
    override function dispose() {
        _data.dispose();
        _data = null;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _data:ImageData;
}