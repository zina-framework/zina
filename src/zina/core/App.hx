package zina.core;

/**
 * Make sure your main class extends this class,
 * as it sets up the main game loop
 */
@:autoBuild(zina._backend.macros.AppMacro.build())
class App {
    /**
     * The global instance of the app used to power your games.
     */
    public static var instance(default, null):App;

    /**
     * Constructs a new `App`.
     */
    public function new() {
        if(instance == null)
            instance = this;
    }
}