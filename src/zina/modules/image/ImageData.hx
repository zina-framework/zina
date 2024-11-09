package zina.modules.image;

import cpp.RawPointer;

import stb.Image.UChar;
import stb.Image as StbImage;

/**
 * A class that represents image data.
 */
class ImageData extends Object {
    public var raw:RawPointer<UChar>;

    public function new() {
        super();
    }

    public function getWidth():Int {
        return _width;
    }

    public function getHeight():Int {
        return _height;
    }

    public function getChannels():Int {
        return _channels;
    }

    override function dispose() {
        StbImage.freeImage(raw);
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _width:Int = 0;
    private var _height:Int = 0;
    private var _channels:Int = 0;
}