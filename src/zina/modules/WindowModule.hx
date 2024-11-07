package zina.modules;

import sdl.SDL;
import sdl.Types;

import glad.Glad;

import zina.data.ProjectConfig;

/**
 * The module responsible for controlling window-related things.
 */
class WindowModule {
    /**
     * Constructs a new `WindowModule`.
     */
    public function new() {
        var wFlags:SDLWindowInitFlags = OPENGL;
        final conf:WindowConfig = Zina.config.window;
        
		if (conf.resizable)
			wFlags |= RESIZABLE;
		
		if (conf.borderless)
			wFlags |= BORDERLESS;

        _window = SDL.createWindow(conf.title, SDLWindowPos.CENTERED, SDLWindowPos.CENTERED, conf.width, conf.height, SDLWindowInitFlags.OPENGL);
        _context = SDL.glCreateContext(_window);

        SDL.glMakeCurrent(_window, _context);
        SDL.glSetSwapInterval((conf.vsync) ? 1 : 0);

        Glad.loadGLLoader(untyped __cpp__("SDL_GL_GetProcAddress"));
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _window:SDLWindow;
    private var _context:SDLGlContext;
}