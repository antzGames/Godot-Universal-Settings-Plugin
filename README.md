# Godot Universal Settings Plugin

A versatile, renderer-aware settings screen for Godot 4.5 that seamlessly adapts across all renderers 
and HTML web builds.

This plugin simplifies user settings management by saving and reloading configurations for graphics, audio settings, and keybinds, ensuring a consistent experience across platforms.

<img src="https://github.com/user-attachments/assets/e6a93658-f99d-4f48-8c93-b955ec0ce274" width="640">

Version 1.2 has many QoL features.

## Table of Contents

- [Features](#features)
- [Supported Settings](#supported-settings)
  -	[Graphics Settings](#graphics-settings)
  - [Audio Settings](#audio-settings)
- [Supported Settings by Renderer](#supported-settings-by-renderer)
- [Why Use This Plugin](#why-use-this-plugin)
- [Installation](#installation)
- [How to Use](#how-to-use)
  - [Show Me a Complete Step-by-Step Example](#show-me-a-complete-step-by-step-example)
- [How to Apply a Theme](#how-to-apply-a-theme)
- [Audio Bus Configuration](#audio-bus-configuration)
- [Configuring Default Settings and Dropdowns](#configuring-default-settings-and-dropdowns)
- [Keybinds](#keybinds)
- [How to Delete My Saved Settings](#how-to-delete-my-saved-settings)
- [Demos Included](#demos-included)
- [Sponza Demo](#sponza-demo)
- [Video Tutorial](#video-tutorial)
- [More Settings Planned?](#more-settings-planned)
- [Attribution And License](#attribution-and-license)

## Features

**Persistent Settings**: Saves user graphics, audio preferences, and keybinds, reloading them on game startup.

**One-Line Integration**: A single function call to display the settings screen.  Also includes a signal.

**Renderer Awareness**: Automatically adapts to the current renderer, ensuring feature compatibility (more on this [below](#supported-settings-by-renderer)).

**Platform Agnostic**: Works out-of-the-box with HTML/Web builds, mobile, and desktop platforms.

**Audio Bus Auto Configure**: Supports auto configure of up to 5 Audio buses, including the Master bus.

**Up to 10 Keybinds**: Ability to chose which actions in the Project Settings `InputMap` are included in the Keybinds.

**Customizable Themes**: Supports applying themes to the settings screen, with 4 themes included in the demo project.

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

The plugin supports adjusting and saving the volume of up to 5 audio buses, including the Master bus.

No configuation needed.

## Supported Settings by Renderer

Here is a table of the supported settings based on the renderer:

<img src="https://github.com/user-attachments/assets/3fa70c81-26e3-479a-a59b-15c105f5c1fa" width="640">

Mobile renderer's `Monitor Selection`, `Window/Fullscreen Mode`, `Window Resolution` and `VSync` settings not supported if running on Android or iOS, otherwise it is supported.

Please note, you will need to wait for Godot 4.6 to fix the 3D scaling amount issue with the Compaitibility renderer. See: https://github.com/godotengine/godot/issues/107552

## Why Use This Plugin

**Seamless Exporting**:
No code modifications are required when exporting to HTML/Web or mobile platforms. The settings screen works consistently across all build targets.

**Dynamic Feature Adaptation**:
Certain features may not be available on all renderers. This plugin automatically adjusts the settings screen, enabling or disabling features as needed based on the current renderer.

**Ease of Integration**:
Being a plugin, it provides a ready-to-use settings screen with just one line of code. Applying themes is equally simple and efficient.

## Installation

**Option 1**: Use this repository as a project template.  Best for beginners.

1. Download or clone this repository.
2. Start creating a new game by making a new scene.
3. Set your new scene as the main scene.

**Option 2**: Use as a plugin only.

1. Download or clone this repository.  (Godot AssetLib coming soon)
2. Copy the this repository's `addons/universal_settings_plugin` folder into your Godot project under `res://addons/universal_settings_plugin/`.
3. Enable the plugin in the Project Settings under the Plugins tab.
4. See `Audio bus configuration` section [below](#audio-bus-configuration) to name your audio bus names correctly.

## How to Use 

1. Enable the plugin as described [above](#installation).
2. Call the settings screen with the following code:
```gdscript
UniversalSettings.show_screen()
```
You can also emit a signal to show the setting screen:
```gdscript
UniversalSettings.show_settings_screen.emit()
```

3. Change any setting you like.  Changes are applied in real time.
4. Clicking `Save` on the settings screen will save the settings and hide the settings screen.

### Show Me a Complete Step-by-Step Example

1. Create a new Godot project.
2. Enable the plugin as described [above](#installation).
3. Create a scene.  
4. Attach a script to it. 
5. Add the following code to the script:

```gdscript
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		UniversalSettings.show_screen()
```	

6. Run your scene.
7. Pressing `SPACE` or `ENTER` will bring up the settings screen.
8. Clicking `Save` will save your settings.

## How to Apply a Theme

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

The demo project has examples on how to apply themes, tab container size, and tab container color.

## Audio Bus Configuration

The plugin will query the `AudioServer` and place up to 5 configured buses in the settings screen automatically.

## Configuring Default Settings and Dropdowns

### Default Settings

There is an very important file named `settings_data_resource.gd` that extends `Resource`, located in the `config` directory of the plugin.

This file has 2 purposes:

- stores default values of all settings, and used when the game is run for the first time without settings being saved.
- used as a template for the settings save file.

When a save file does not exist or cannot be found, then the plugin will look at this file for the default settings.

The source code of this file is well documented, so if you need to change the default settings on the first time a user plays your game this is the file you need to modify.

**Keep in mind that the default settings in this file will supersede any project settings.**

### Dropdowns

The only way to modify the dropdowns is by updating the dictionaries in the plugin's main script:

`universal_settings_menu.gd`

You most likely want to modify the window resolutions dictionary:

```gdscript
# You can modify these window resolutions to your liking, 
# but there must to be at least ONE entry.
# Make sure your default resolution is set in the settings_data_resource.gd file
@export var resolutions : Dictionary = {
  "1280x720"  :  Vector2i(1280, 720),  # index 0
  "1440x810"  :  Vector2i(1440, 810),  # index 1
  "1600x900"  :  Vector2i(1600, 900),  # index 2
  "1920x1080" :  Vector2i(1920, 1080)} # index 3
```

Feel free to modify the resolutions, but make sure you set the correct index for the default in the `settings_data_resource.gd` file.

### Keybinds

Keybinds allow you to set and persist new keyboard and mouse buttons assignments for up to 10 actions set in your `Project` > `Project Settings` > `Input Map` configuration.  Both builtin and custom actions supported.

Here are the limitations:
- Up to 10 actions can be displayed in the keybind tab.
- Only one event per action is stored.
- Only keyboard and mouse button events supported.
- No controller/gamepad support.

Using keybinds requires you to configure the actions in the `KeybindsConfig.tscn` scene in the `res://addons/universal_settings/config` directory.

You will need to select your keybind actions (up to 10) and set the action descriptions.  

<img width="635" height="759" alt="us-keys" src="https://github.com/user-attachments/assets/4d618c86-32a2-43e1-9464-68c7da567ea2" />


## How to Delete My Saved Settings

If you want to delete your saved settings on desktop:

`Project` > `Open User Data Folder` > `game_data` > `settings_dataXXX.tres`

The XXX is the `application/config/version` of your project.

This makes it easy to force a reset of any saved settings on previous game versions of your user install base by just incrementing the version in your project.  

To delete saved settings on HTML/Web builds, purge local browser storage. These instructions are browser-specific.

## Demos Included

**Godot 3D Plush Test**:

This is a dynamic 3D scene with the Godot 3D plush model with a collection of boxes raining down.

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
	UniversalSettings.show_screen()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"): UniversalSettings.show_screen()
```	
<img src="https://github.com/user-attachments/assets/114033a0-5471-4452-895b-de59fb46fe12" width="572">

## Sponza Demo

I have added this plugin to the godot-sponza-4 demo in a fork at:

https://github.com/antzGames/godot-sponza-4

This projects makes it easier to notice how the MSAA, FSR 1.0, FSR 2.2, TAA, FXAA, and 3D scaling settings affect the scene and FPS.

<img src="https://github.com/user-attachments/assets/cfd21884-0f00-4cd8-972a-468db8a79e28" width="640">

## Video Tutorial

YouTube video showing the an overview of the alpha release:

https://youtu.be/li1fdAOqewk

YouTube video showing the keybind features and limitations:

https://youtu.be/Di7lJP5SvnI

## More Settings Planned?

The `Forward+` renderer has many more graphics settings that are available.  They include:

- SMAA
- SSR
- SSAO
- SSIL
- SDFGI
- Volumetric Fog

Adding these settings to this plugin should be easy, as all I need to do is make them visible only when the renderer is set to `Forward+`.  This might be available in the future.

There are some quality settings that are supported across all renderers that could be supported in this plugin.  They are:

- Shadow resolution (unfortunately if you change the shadow resolution you need to tweak `shadow_bias`)
- Shadow Filtering (direction and positional)
- Model quality (`mesh_lod_threshold`)

## Attribution And License

Models:

- Godot 3D plush: https://fr3nkd.gumroad.com/l/vhfvy

Themes:

- Godot Windows 10 Themes: https://github.com/mr-dreich/Godot-Windows-10-Theme
- Godot Clashy theme: https://github.com/wadlo/Themey
- Kenney UI Theme: Kenney's UI Pack: https://kenney.nl/assets/ui-pack

License:

This plugin is licensed under the MIT License.
