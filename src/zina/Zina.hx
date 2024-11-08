package zina;

#if !macro
import sdl.SDL;
import sdl.Types;

import cpp.vm.Gc;

import zina._backend.macros.ProjectMacro;

import zina.modules.*;
import zina.modules.EventModule;
#end
import zina.data.ProjectConfig;

/**
 * The main class for accessing all of Zina's capabilities.
 * 
 * It contains all of the modules you need for
 * making games, such as `graphics`, `audio`, etc.
 */
class Zina {
    /**
     * The configuration data for your game.
     */
    public static var config(default, null):ProjectConfig;

    #if !macro
    /**
     * A map of functions that handle several of Zina's events.
     */
    public static var handlers(default, null):Map<EventType, Array<Dynamic>->Void> = [];
    
    /**
     * Direct access to the `event` module of Zina.
     */
    public static var event(default, null):EventModule;

    /**
     * Direct access to the `window` module of Zina.
     */
    public static var window(default, null):WindowModule;

    /**
     * Direct access to the `graphics` module of Zina.
     */
    public static var graphics(default, null):GraphicsModule;

    /**
     * Direct access to the `audio` module of Zina.
     */
    public static var audio(default, null):AudioModule;

    /**
     * Direct access to the `timer` module of Zina.
     */
    public static var timer(default, null):TimerModule;
    #end

    /**
     * The function that runs when Zina is ready to
     * start *your* game logic.
     * 
     * You should use this function to **initialize**
     * your game's variables and logic!
     */
    public static dynamic function load():Void {}

    /**
     * The function that runs when Zina is ready to
     * quit your game.
     * 
     * You should use this function to **de-initialize**
     * your game's variables and logic!
     * 
     * If you don't want to quit just yet, just return `false`.
     */
    public static dynamic function quit():Bool {
        return true;
    }

    /**
     * The function that runs when the window
     * is resized by the user.
     * 
     * @param  width   The new width of the window.
     * @param  height  The new height of the window. 
     */
    public static dynamic function resize(width:Int, height:Int):Void {}

    /**
     * Updates *your* game logic.
     * 
     * This function is called once every frame.
     * 
     * @param  dt  Time since the last frame. (in seconds)
     */
    public static dynamic function update(dt:Float):Void {}

    /**
     * Draws *your* game to the screen.
     * 
     * This function is called once every frame.
     */
    public static dynamic function draw():Void {}

    /**
     * Sets up the main game loop and starts running it.
     * 
     * You can override this function for finer control over
     * how you want your game to behave.
     */
    public static dynamic function run():Void {
        #if !macro
        if(load != null)
            load();
        
        // Don't include time taken to load in the
        // first frame's delta time
        if(timer != null)
            timer.step();

        // Track delta time
        var dt:Float = 0;

        // For drawing at target FPS, but updating as fast as possible
        var drawTimer:Float = 0;

        // Main game loop
        while(true) {
            // Process events
            if(event != null) {
                event.pump();

                final polled:Array<PolledEvent> = event.poll();
                for(i in 0...polled.length) {
                    final event:PolledEvent = polled[i];
                    final handler:Array<Dynamic>->Void = handlers.get(event.type);
                    if(handler != null)
                        handler(event.data);
                }
            }
            
            // Update delta time, because we'll have to pass it to update
            if(timer != null)
                dt = timer.step();
            
            // Call update and draw
            if(update != null)
                update(dt);
            
            final capDt:Float = (config.targetFPS > 0 && !config.vsync) ? 1 / config.targetFPS : 0;
            drawTimer += dt;

            if(capDt == 0 || drawTimer >= capDt) {
                if(graphics != null) {
                    graphics.origin();
                    graphics.clear(graphics.getBackgroundColor());
                    
                    if(draw != null)
                        draw();
                    
                    graphics.present();
                }
                drawTimer %= capDt;
            }

            // Call garbage collector since our custom
            // game loop seemingly overrides the automatic firing
            Gc.run(true);
        }
        #end
    }

    /**
     * Sets up a few internal variables and then starts
     * the game by calling `run()`.
     */
    public static function begin():Void {
        #if !macro
        if(SDL.init(VIDEO | EVENTS) < 0) {
            Sys.println('Failed to initialize SDL: ${SDL.getError()}');
            Sys.exit(1);
        }
        config = ProjectMacro.getConfig();

        window = new WindowModule();
        handlers.set(RESIZED, (data:Array<Dynamic>) -> {
            @:privateAccess
            window._onResize(data[0], data[1]);

            if(resize != null)
                resize(data[0], data[1]);
        });
        handlers.set(QUIT, (data:Array<Dynamic>) -> {
            if(quit == null || !quit())
                return;

            end();
            Sys.exit(0);
        });
        if(config.event)
            Zina.event = new EventModule();
        
        if(config.graphics)
            Zina.graphics = new GraphicsModule();
        
        if(config.audio)
            Zina.audio = new AudioModule();
        
        if(config.timer)
            Zina.timer = new TimerModule();

        if(run == null) {
            Sys.println('Zina.run() was not defined!');
            Sys.exit(1);
        }
        run();
        trace("run called");
        end();
        #end
    }

    /**
     * Disposes of a few internal variables.
     */
    public static function end():Void {
        #if !macro
        SDL.quit();
        #end
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //
}