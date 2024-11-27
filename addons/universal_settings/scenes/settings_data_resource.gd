extends Resource
class_name SettingsDataResource

# This file defines the structure of the settings save file.
# It containes the variables needed to persist and more importantly,
# sets the DEFAULT settings the first time your game is run.

@export var monitor_number : int  = 0

# "Fullscreen"       : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
# "Window"           : DisplayServer.WINDOW_MODE_WINDOWED
# "Window Maximized" : DisplayServer.WINDOW_MODE_MAXIMIZED
@export var window_mode : int  = 1      # default is WINDOWED
@export var window_mode_index : int = 1 # index of dropdown for WINDOWED

# Window Resolution Info:
# "1440x810"  :  Vector2i(1440, 810)  # index 0
# "1600x900"  :  Vector2i(1600, 900)  # index 1
# "1920x1080" :  Vector2i(1920, 1080) # index 2

# The following is the default window resolution.   This will override any project settings.
# This Vector2i needs to be in resolutions dictionary in universal_settings_menu.gd
@export var resolution : Vector2i = Vector2i(1440,810)  
@export var resolution_index : int = 0 # this needs to be the correct index in the resolutions dictionary

@export var msaa_3d = 2        # default MSAA set to 4X
@export var msaa_3d_index = 2  # 0 = none, 1 = 2X, 2 = 4X, 3 = 8X

@export var fsr_mode = 0       # default is Bilinear
@export var fsr_mode_index = 0 # 0 = Bilinear, 1 = FSR 1.0, 2 = FSR 2.2

# 3D scaling: 0 = 50%, 1 = 59%, 2 = 67%, 3 = 77%, 4 = 100%
@export var scale_3d : int = 4 # default is 100% = no scaling

# Volumes - You can set the default volumes here (0..1)
@export var master_volume : float = 1.0
@export var sfx_volume : float = 1.0
@export var music_volume : float = 1.0
@export var voice_volume : float = 1.0

# Defaults for checkboxes
@export var fxaa : Viewport.ScreenSpaceAA = Viewport.SCREEN_SPACE_AA_DISABLED
@export var taa : bool = false
@export var vsync : DisplayServer.VSyncMode = DisplayServer.VSYNC_ENABLED
