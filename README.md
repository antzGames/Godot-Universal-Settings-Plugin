# Godot Universal Settings Plugin

A versatile, renderer-aware settings screen for Godot 4.3 that seamlessly adapts across all renderers 
and HTML web builds.

This plugin simplifies user settings management by saving and reloading configurations for graphics 
and audio settings, ensuring a consistent experience across platforms.

<img src="https://github.com/user-attachments/assets/759c17c0-0a41-473d-bedc-4e3e22cde3db" width="640">

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
- [How to Delete My Saved Settings](#how-to-delete-my-saved-settings)
- [Demos Included](#demos-included)
- [Video Tutorial](#video-tutorial)
- [More Settings Planned?](#more-settings-planned)
- [Attribution And License](#attribution-and-license)

## Features

**Persistent Settings**: Saves user graphics and audio preferences, reloading them on game startup.

**One-Line Integration**: A single function call to display the settings screen.

**Renderer Awareness**: Automatically adapts to the current renderer, ensuring feature compatibility (more on this below).

**Platform Agnostic**: Works out-of-the-box with HTML/Web builds, mobile, and desktop platforms.

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

The plugin supports adjusting and saving the volume of up to 4 audio buses. The plugin includes four predefined audio bus names:

- Master
- Music
- SFX
- Voice

The `Master` bus is mandatory, but if you do not have the remaining audio buses (Music, SFX, Voice) configured in your project, the plugin will automatically not show them in the settings screen.  There is more information about audio settings and configuring audio buses further down.

## Supported Settings by Renderer

Here is a table of the supported settings based on the renderer:

![supported](https://github.com/user-attachments/assets/a79b268c-8951-4b01-8048-0be181473e0d)

## Why Use This Plugin

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
4. See `Audio bus configuration` section below to name your audio bus names correctly.

## How to Use 

1. Enable the plugin as described above.
2. Call the settings screen with the following code:
```gdscript
UniversalSettings.show_screen()
```
3. Change any setting you like.  Changes are applied in real time.
4. Clicking `Save` on the settings screen will save the settings and hide the settings screen.

### Show Me a Complete Step-by-Step Example

1. Enable the plugin as described above.
2. Create a scene.  
3. Attach a script to it. 
4. Add the following code.

```gdscript
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		UniversalSettings.show_screen()
```	

5. Run your scene.
6. Pressing `SPACE` or `ENTER` will bring up the settings screen.
7. Clicking `Save` will save your settings.

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

The demo project has examples on how to apply themes, tab size, and tab color.

## Audio Bus Configuration

Unfortunately, I am not dynamically querying the audio buses from the project because it complicates keeping the saved settings in sync with changes to the project's audio buses information.  I might do it in the future.

This means you have 3 options.

### Option 1: Do Nothing

Especially good choice for a newly created projects.  Doing nothing means that only the `Master` bus volume control will show up on the settings menu.  If this is all you need, you do not have to do anything, ever.

### Option 2: Configure Your Audio Bus Names to Match the Plugin

Right now the plugin supports the `Master` audio bus and 3 additional audio buses, and they **need** to be called Music, SFX, and Voice > **IF you do not want to modify the plugin**.

This is the easiest approach.  Just configure your audio buses to the following:

<img src="https://github.com/user-attachments/assets/c4493891-5441-4c5b-b3d5-c99bfb5ef00f" width="511">

### Option 3: Update Plugin for Custom Audio Bus Names

The other option is to update the name of the audio bus right in the plugin scene.  This can be done in the Inspector of the editor.

To change the name of the plugin's audio bus follow these instructions:

1. Open the `universal_settings_menu.tscn` scene in the `res://addons/universal_settings/scenes/` folder.
2. Expand the nodes until you see the `Audio` TabBar node.
3. Expand all the `Audio` TabBar children.
4. You should see a node structure as shown in the image below.
5. Select `VoiceSlider` node as this is most likely the audio bus name you will want to change.
6. Change `Bus Name` property in the Inspector to the name of your audio bus.

Keep in mind if the plugin does not find your bus with the name you provided, then it will:

- show an warning in the console telling you the bus name was not found.
- disables this audio bus. This means you will no longer see this audio bus in the settings screen.
- however the plugin will still work.

<img src="https://github.com/user-attachments/assets/5e4711e6-7590-48ed-81f5-589eddaa323f" width="582">

## Configuring Default Settings and Dropdowns

The main configuration of the settings screen such as:

- dictionaries that configure the drop downs for window modes, resolutions, MSAA modes, and 3D scaling modes.
- default values of all settings, used when the game is run for the first time without settings being saved.

is stored as `Resource` file called `settings_data_resource.gd`.  It is located in the `config` directory of the plugin.

The source code is well documented, so if you need to change the default settings on the first time a user plays your game
or you need change the resolution list, then this is the file you need to modify.

Keep in mind that the default settings in this file will supersede any project settings.  An example of this is the window resolution or window mode.

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
<img src="https://github.com/user-attachments/assets/d627ebd9-22bc-49f6-9690-4fb7f303db77" width="626">

## Video Tutorial


## More Settings Planned?

The `Forward+` renderer has many more graphics settings that are available.  They include:

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
