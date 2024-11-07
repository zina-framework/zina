# <img src="https://raw.githubusercontent.com/zina-framework/.github/refs/heads/main/profile/zina_no_bg_shadowless.png" alt="zina.hx logo" width="24" /> zina.hx
Zina is a small 2D game framework designed to have a simple, yet flexible API.

Think of [LÖVE](https://love2d.org/), but built in a Haxe environment!

> [!IMPORTANT]
> Zina requires Haxe 4.3+ to compile, it will likely not work on anything below.

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
    conf.assetFolders = [ // A list of several folders your game may use to hold assets
        {
            "name": "assets", // The name of a folder to pull assets from
            "embed": false // Whether or not this folder's contents will be embedded into the final executable
        }
    ];
}
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
