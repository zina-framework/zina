package zina.modules.event;

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