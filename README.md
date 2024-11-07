# <img src="https://raw.githubusercontent.com/zina-framework/.github/refs/heads/main/profile/zina_no_bg_shadowless.png" alt="zina.hx logo" width="24" /> zina.hx
Zina is a small 2D game framework designed to have a simple, yet flexible API.

Think of [LÖVE](https://love2d.org/), but built in a Haxe environment!

> [!IMPORTANT]
> Zina requires Haxe 4.3+ to compile, it will likely not work on anything below.

## 💡 Getting Started

In order to start using Zina, start by installing the haxelib:

### ⚡ Development Installation
This will install the very latest, potentially unstable version of Zina.

```sh
haxelib git zina https://github.com/zina-framework/zina
```
On Linux, you will need to run some commands for Zina to run correctly.

The commands depend on your distro, and if it isn't on this list here,
let me know so i can add more! In the meanwhile, try looking them up.

Here is a list of each command needed:

### 🐌 Debian/Ubuntu
```sh
sudo apt install g++
sudo apt install libsdl2-dev -y
sudo apt install libopengl-dev -y
sudo apt install libopenal-dev -y
```

### ⚡ Arch Linux

```sh
sudo pacman -S gcc
sudo pacman -S sdl2
sudo pacman -S mesa
sudo pacman -S openal
```

## ⚙️ Configuration
Configuring a Zina project is pretty simple, all you need
to do is make a conf.hx file in your project root!

Use this as an example for how configuration files should be made:
```haxe
function configure(conf) {
    conf.width = 640; // Width of the game area (in pixels)
    conf.height = 480; // Height of the game area (in pixels)

    conf.targetFPS = 144; // Framerate the game should try and reach
    conf.vsync = false; // Whether or not V-Sync will be enabled (overrides `targetFPS`)

    conf.sourceDir = "src"; // The directory/folder which your game's code resides in
    conf.mainClass = "Main"; // The name of the main class that your game will start on
    
    conf.assetFolders = [ // A list of several folders your game may use to hold assets
        {
            name: "assets", // The name of a folder to pull assets from
            embed: false // Whether or not this folder's contents will be embedded into the final executable
        }
    ];
    conf.defines = [ // Defines to use when exporting/testing the project
        // Debugging Defines
        {
            name: "MY_DEBUG_DEFINE",
            value: "1"
        },
        // General Game Defines
        {
            name: "MY_GAME_DEFINE",
            value: "1"
        },
        // Ordering is important! If we try to check
        // for MY_DEBUG_DEFINE before it was defined,
        // it won't work!
        {
            name: "MY_RELEASE_DEFINE",
            value: "1",
            doIf: "MY_GAME_DEFINE",
            doUnless: "MY_DEBUG_DEFINE"
        }
    ];
    conf.exportDir = "export"; // The directory/folder which your game will export to

    conf.graphics = true; // Allows graphics-related functionality in the game
    conf.audio = true; // Allows audio-related functionality in the game
    conf.timer = true; // Allows time-related functionality in the game
}
```

## 🧪 Testing/Exporting
If you want to test your game, this is all you need to run:
```sh
haxelib run zina test -debug
```

That's it! That's all there is to testing your game.
If you want to export your game, you run a very similar command:
```sh
haxelib run zina export
```

## 🖥 Platforms
zina.hx can natively compile to the following platforms via `hxcpp`:

- <img src="https://upload.wikimedia.org/wikipedia/commons/5/5f/Windows_logo_-_2012.svg" width="14" height="14" /> **Windows 8.0+**
- <img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Apple_logo_grey.svg" width="12" height="14" /> **macOS Ventura+**
- <img src="https://upload.wikimedia.org/wikipedia/commons/3/35/Tux.svg" width="14" height="14" /> **Linux** (Ubuntu, Debian, Fedora, openSUSE, Arch)

## 🧱 Libraries
zina.hx uses a few other libraries to work, such as:

- <img src="https://upload.wikimedia.org/wikipedia/commons/1/16/Simple_DirectMedia_Layer%2C_Logo.svg" width="24" height="14" /> **[hxsdl](https://github.com/swordcube/hxsdl)**
  - 🪟 Spawns the main game window
  - 🖱️ Handles input for keyboard, mouse, and controllers.

- 🖼️ **[hxstb_image](https://github.com/swordcube/hxstb_image)**
  - 🖥 Responsible for loading the data of `PNG`, `JPG`, `BMP`, and `HDR` files

- <img src="https://upload.wikimedia.org/wikipedia/commons/e/e9/Opengl-logo.svg" width="24" height="14" /> **[hxglad](https://github.com/swordcube/hxglad)**
  - 🖼️ Renders textures to the game window
  - 📷 Allows shaders to be applied to textures

- 🎵 **[hxdr_mp3](https://github.com/swordcube/hxdr_mp3)**
  - 🖥 Responsible for loading the data of MP3 files

- 🎵 **[hxdr_wav](https://github.com/swordcube/hxdr_wav)**
  - 🖥 Responsible for loading the data of WAV files

- 🎵 **[hxstb_vorbis](https://github.com/swordcube/hxstb_vorbis)**
  - 🖥 Responsible for loading the data of OGG files

- <img src="https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/OpenAL_logo.svg/1280px-OpenAL_logo.svg.png" width="30" height="14" /> **[hxal](https://github.com/swordcube/hxal)**
  - 🔊 Responsible for playing back the data of compatible audio files
