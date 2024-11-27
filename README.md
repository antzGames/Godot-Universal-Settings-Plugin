# Godot Universal Settings Plugin

A versatile, renderer-aware settings screen for Godot 4.3 that seamlessly adapts across all renderers 
and HTML web builds.

This plugin simplifies user settings management by saving and reloading configurations for graphics 
and audio settings, ensuring a consistent experience across platforms.

<img src="https://github.com/user-attachments/assets/759c17c0-0a41-473d-bedc-4e3e22cde3db" width="720">


## Features

**Persistent Settings**: Saves user graphics and audio preferences, reloading them on game startup.

**One-Line Integration**: A single function call to display the settings screen.

**Renderer Awareness**: Automatically adapts to the current renderer, ensuring feature compatibility (more on this below).

**Platform Agnostic**: Works out-of-the-box with HTML/Web builds, mobile, and desktop platforms.

**Customizable Themes**: Supports applying themes to the settings screen, with 4 pre-designed themes included in the demo project.

**Demo Included**: Comes with a sample project featuring the Godot 3D plush to showcase functionality.

## Supported Settings

### Graphics Settings

The following graphics options are dynamically adjusted based on the renderer:

- Monitor Selection
- Window Mode: Fullscreen/Windowed
- Window Resolution Selection
- Anti-Aliasing: MSAA (None, 2X, 4X, 8X)
- 3D Scaling Mode: Bilinear, FSR 1.0, FSR 2.2
- 3D Scaling Amount
- FXAA
- TAA
- VSync

### Audio Settings

The plugin supports adjusting and saving the volume of up to 4 audio buses. The plugin includes four predefined audio bus names:

- Master
- Music
- SFX
- Voice

The `Master` bus is mandatory, but if you do not have the remaining audio buses (Music, SFX, Voice) configured in your project, the plugin will automatically not show them in the settings screen.  There is more information about audio settings and configuring audio buses further down.

## Supported Settings by Renderer

Here is a table of the supported settings based on the renderer:

![supported](https://github.com/user-attachments/assets/a79b268c-8951-4b01-8048-0be181473e0d)


## Why Renderer Awareness Matters

**Seamless Exporting**:
No code modifications are required when exporting to HTML/Web or mobile platforms. The settings screen works consistently across all build targets.

**Dynamic Feature Adaptation**:
Certain features may not be available on all renderers. This plugin automatically adjusts the settings screen, enabling or disabling features as needed based on the current renderer.

**Ease of Integration**:
Being a plugin, it provides a ready-to-use settings screen with just one line of code. Applying themes is equally simple and efficient.

## Installation

1. Download the plugin from this repository.
2. Copy the plugin folder into your Godot project under `res://addons/universal_settings_plugin/`.
3. Enable the plugin in the Project Settings under the Plugins tab.

## How to Use 

1. Enable the plugin as described above.
2. Call the settings screen with the following code:
```gdscript
UniversalSettings.show_screen()
```
3. Change any setting you like.  Changes are applied in real time.
4. Clicking `Save` on the settings screen will save the settings and hide the settings screen.

## How to apply a theme

You have the ability to apply a theme to the settings screen.  The plugin can load any theme based 
on the path you provide. To apply a theme:

```gdscript
UniversalSettings.set_theme_to("res://path/to/theme/mytheme.tres")
```
You can also change the size of tab container by providing a `Vector2` to the function call:

```gdscript
UniversalSettings.set_theme_to("res://path/to/theme/mytheme.tres", Vector2(550,510))
```
You can also assign a self modulate color to the tab container:

```gdscript
UniversalSettings.set_theme_to("res://path/to/theme/mytheme.tres", Vector2(550,510), Color.BLUE)
```

The demo project has examples on how to apply themes, tab size, and tab color.

## Audio bus configuration

## Configuring default settings

Both the initial default value of all the settings and the saved setting configuration are stored in a `Resource` file called `settings_data_resource.gd`.

The source code is well documented, so if you need to change the default settings on the first time a user plays your game
then this is the file you need to modify.

Keep in mind that settings in this file will supersede any project settings.  An example of this is the window resolution or window mode.

## How to delete my saved settings

If you want to delete your saved settings on desktop:

`Project` > `Open User Data Folder` > `game_data` > `settings_dataXXX.tres`

The XXX is the `application/config/version` of your project.

This makes it easy to force a reset of any saved settings on previous game versions of your user install base by just incrementing the version in your project.  

To delete saved settings on HTML/Web builds, purge local browser storage. These instructions are browser-specific.

## Demos included

## Attribution and License

This plugin is licensed under the MIT License.
