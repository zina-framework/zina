package zina.modules.event;

import sdl.Types;

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