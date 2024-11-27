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

**Option 1**: Use as a project template.  Best for beginners.

1. Download or clone this repository.
2. Start creating a new game by making a new scene.
3. Set your new scene as the main scene.

**Option 2**: Use the plugin

1. Download or clone this repository.  (Godot AssetLib coming soon)
2. Copy the this repository's `addons/universal_settings_plugin` folder into your Godot project under `res://addons/universal_settings_plugin/`.
3. Enable the plugin in the Project Settings under the Plugins tab.
4. If you have more than the default `Master` audio bus, make sure you rename them to Music, SFX.

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

Unfortunately, I am not dynamically quering audio buses layouts.  Right now the plugin supports the `Master` audio bus and 3 additional audio buses, and they need to be called Music, SFX, and Voice if you do not want to modify the plugin.

This is the easiest approach.  Just conigufure your audio bus to look like the following:



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

**Godot 3D Plush Test**:

This is a dynamic 3D scene with the Godot 3D plush model with a buch of boxes raining down.

This is a good demo to show how to change the theme, tab container size, and color of the settings screen:

```gdscript
# If no theme is set then the default Godot theme is used,
# but you can easily change themes... pick one!
UniversalSettings.set_theme_to("res://demo/assets/themes/clashy/clashy.tres", Vector2(550,510), Color(1,1,1,0.5))
#UniversalSettings.set_theme_to("res://demo/assets/themes/windows_10_light/theme.tres", Vector2(550, 345), Color(0,0.471,0.831,0.5))
#UniversalSettings.set_theme_to("res://demo/assets/themes/windows_10_dark/theme.tres", Vector2(550, 345), Color(1,1,1,0.5))
#UniversalSettings.set_theme_to("res://demo/assets/themes/kenney/kenneyUI.tres")
```

**Blank Scene**:

This is an ultra minimalist demo of the plugin.  Its only 4 lines of code!

It uses the default theme of the project.

You will need to set this scene as `Set as Main Scene` in the editor to run this demo.

```gdscript
func _ready() -> void:
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	UniversalSettings.show_screen()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"): 
		UniversalSettings.show_screen()  # will do nothing if already visible
```	
<img src="https://github.com/user-attachments/assets/d627ebd9-22bc-49f6-9690-4fb7f303db77" width="516">

## Any video tutorials?

## Attribution and License

This plugin is licensed under the MIT License.
