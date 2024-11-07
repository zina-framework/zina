package zina.modules;

import sdl.SDL;
import sdl.Types;

/**
 * The module responsible for controlling event-related things.
 */
class EventModule {
    /**
     * Constructs a new `EventModule`.
     */
    public function new() {
        _ev = SDL.makeEvent();
    }

    public function pump():Void {
        _polledEvents.resize(0);
    }

    public function poll():Array<EventType> {
        while(SDL.pollEvent(_ev) != 0) {
            switch(_ev.ref.type) {
                case WINDOWEVENT:
                    switch(_ev.ref.window.event) {
                        case MINIMIZED:
                            _polledEvents.push(EventType.MINIMIZE);

                        case MAXIMIZED:
                            _polledEvents.push(EventType.MAXIMIZE);

                        case RESTORED:
                            _polledEvents.push(EventType.RESTORED);

                        case FOCUS_GAINED:
                            _polledEvents.push(EventType.FOCUS_GAINED);

                        case FOCUS_LOST:
                            _polledEvents.push(EventType.FOCUS_LOST);

                        case RESIZED:
                            _polledEvents.push(EventType.RESIZED);
                    }

                case KEYDOWN:
                    _polledEvents.push(EventType.KEY_DOWN);

                case KEYUP:
                    _polledEvents.push(EventType.KEY_UP);

                case MOUSEMOTION:
                    _polledEvents.push(EventType.MOUSE_MOTION);

                case MOUSEBUTTONDOWN:
                    _polledEvents.push(EventType.MOUSE_BUTTON_DOWN);

                case MOUSEBUTTONUP:
                    _polledEvents.push(EventType.MOUSE_BUTTON_UP);

                case DROPFILE:
                    _polledEvents.push(EventType.DROP_FILE);

                case QUIT:
                    _polledEvents.push(EventType.QUIT);
            }
        }
        return _polledEvents;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private static var _ev:SDLEvent;
    private static var _polledEvents:Array<EventType> = [];
}

enum abstract EventType(Int) from Int to Int {
    final QUIT = SDLEventType.QUIT;
    final MINIMIZE = SDLEventType.MINIMIZE;
    final MAXIMIZE = SDLEventType.MAXIMIZE;
    final RESTORED = SDLEventType.RESTORE;
    final FOCUS_GAINED = SDLWindowEventID.FOCUS_GAINED;
    final FOCUS_LOST = SDLWindowEventID.FOCUS_LOST;
    final RESIZED = SDLEventType.RESIZED;
    final KEY_DOWN = SDLEventType.KEYDOWN;
    final KEY_UP = SDLEventType.KEYUP;
    final MOUSE_MOTION = SDLEventType.MOUSEMOTION;
    final MOUSE_BUTTON_DOWN = SDLEventType.MOUSEBUTTONDOWN;
    final MOUSE_BUTTON_UP = SDLEventType.MOUSEBUTTONUP;
    final DROP_FILE = SDLEventType.DROPFILE;
}