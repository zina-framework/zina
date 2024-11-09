package zina.modules.timer;

import haxe.Timer as HaxeTimer;

/**
 * The module responsible for controlling time-related things.
 */
class TimerModule {
    /**
     * Constructs a new `TimerModule`.
     */
    public function new() {}

    /**
     * Measures the time between two frames.
     * 
     * Calling this will change the return value of `getDelta`.
     * 
     * @return The time passed. (in seconds)
     */
    public function step():Float {
        final now:Float = HaxeTimer.stamp();
        _dt = (now - _last);
        _last = now;
        return _dt;
    }

    /**
     * Returns the time since the last frame. (in seconds)
     */
    public function getDelta():Float {
        return _dt;
    }

    /**
     * Pauses the whole game for a specified
     * amount of time.
     * 
     * Useful for capping FPS.
     * 
     * @param  time  Time to sleep for. (in seconds)
     */
    public function sleep(time:Float):Void {
        final now:Float = HaxeTimer.stamp();
        Sys.sleep(time);
        #if windows
        while(HaxeTimer.stamp() - now < time) {
            // Busy wait the rest of this because
            // Windows' sleep function is very inaccurate
        }
        #end
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _last:Float;
    private var _dt:Float;
}