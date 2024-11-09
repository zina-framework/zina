package zina.modules.image;

import cpp.Pointer;
import cpp.RawPointer;

import stb.Image.UChar;
import stb.Image as StbImage;

/**
 * The module responsible for controlling image-related things.
 */
@:access(zina.modules.image.Image)
@:access(zina.modules.image.ImageData)
class ImageModule {
    /**
     * Constructs a new `ImageModule`.
     */
    public function new() {}

    public overload extern inline function newImage(filePath:String):Image {
        final image:Image = new Image();
        return image;
    }

    public overload extern inline function newImageData(filePath:String):ImageData {
        final image:ImageData = new ImageData();
        final raw:RawPointer<UChar> = cast StbImage.load(filePath, Pointer.addressOf(image._width), Pointer.addressOf(image._height), Pointer.addressOf(image._channels), 0);
        return image;
    }
}