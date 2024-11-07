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

    public function poll():Array<PolledEvent> {
        while(SDL.pollEvent(_ev) != 0) {
            switch(_ev.ref.type) {
                case WINDOWEVENT:
                    switch(_ev.ref.window.event) {
                        case MINIMIZED:
                            _polledEvents.push({
                                type: EventType.MINIMIZE,
                                data: null
                            });

                        case MAXIMIZED:
                            _polledEvents.push({
                                type: EventType.MAXIMIZE,
                                data: null
                            });

                        case RESTORED:
                            _polledEvents.push({
                                type: EventType.RESTORED,
                                data: null
                            });

                        case FOCUS_GAINED:
                            _polledEvents.push({
                                type: EventType.FOCUS_GAINED,
                                data: null
                            });

                        case FOCUS_LOST:
                            _polledEvents.push({
                                type: EventType.FOCUS_LOST,
                                data: null
                            });

                        case RESIZED:
                            _polledEvents.push({
                                type: EventType.RESIZED,
                                data: [_ev.ref.window.data1, _ev.ref.window.data2]
                            });

                        default:
                    }

                case KEYDOWN:
                    _polledEvents.push({
                        type: EventType.KEY_DOWN,
                        data: [_ev.ref.key.keysym.sym]
                    });

                case KEYUP:
                    _polledEvents.push({
                        type: EventType.KEY_UP,
                        data: [_ev.ref.key.keysym.sym]
                    });

                case MOUSEMOTION:
                    _polledEvents.push({
                        type: EventType.MOUSE_MOTION,
                        data: [_ev.ref.motion.x, _ev.ref.motion.y]
                    });

                case MOUSEBUTTONDOWN:
                    _polledEvents.push({
                        type: EventType.MOUSE_BUTTON_DOWN,
                        data: [_ev.ref.button.button]
                    });

                case MOUSEBUTTONUP:
                    _polledEvents.push({
                        type: EventType.MOUSE_BUTTON_UP,
                        data: [_ev.ref.button.button]
                    });

                case DROPFILE:
                    _polledEvents.push({
                        type: EventType.DROP_FILE,
                        data: [_ev.ref.drop.file]
                    });

                case QUIT:
                    _polledEvents.push({
                        type: EventType.QUIT,
                        data: null
                    });

                default:
            }
        }
        return _polledEvents;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private static var _ev:SDLEvent;
    private static var _polledEvents:Array<PolledEvent> = [];
}

typedef PolledEvent = {
    var type:EventType;
    var data:Array<Dynamic>;
}

enum abstract EventType(Int) from Int to Int {
    final QUIT = SDLEventType.QUIT;
    final MINIMIZE = SDLWindowEventID.MINIMIZED;
    final MAXIMIZE = SDLWindowEventID.MAXIMIZED;
    final RESTORED = SDLWindowEventID.RESTORED;
    final FOCUS_GAINED = SDLWindowEventID.FOCUS_GAINED;
    final FOCUS_LOST = SDLWindowEventID.FOCUS_LOST;
    final RESIZED = SDLWindowEventID.RESIZED;
    final KEY_DOWN = SDLEventType.KEYDOWN;
    final KEY_UP = SDLEventType.KEYUP;
    final MOUSE_MOTION = SDLEventType.MOUSEMOTION;
    final MOUSE_BUTTON_DOWN = SDLEventType.MOUSEBUTTONDOWN;
    final MOUSE_BUTTON_UP = SDLEventType.MOUSEBUTTONUP;
    final DROP_FILE = SDLEventType.DROPFILE;

    @:to
    public function toString():String {
        switch(this) {
            case QUIT:
                return "QUIT";
            
            case MINIMIZE:
                return "MINIMIZE";

            case MAXIMIZE:
                return "MAXIMIZE";

            case RESTORED:
                return "RESTORED";

            case FOCUS_GAINED:
                return "FOCUS_GAINED";

            case FOCUS_LOST:
                return "FOCUS_LOST";

            case RESIZED:
                return "RESIZED";

            case KEY_DOWN:
                return "KEY_DOWN";

            case KEY_UP:
                return "KEY_UP";

            case MOUSE_MOTION:
                return "MOUSE_MOTION";

            case MOUSE_BUTTON_DOWN:
                return "MOUSE_BUTTON_DOWN";

            case MOUSE_BUTTON_UP:
                return "MOUSE_BUTTON_UP";

            case DROP_FILE:
                return "DROP_FILE";
        }
        return null;
    }
}