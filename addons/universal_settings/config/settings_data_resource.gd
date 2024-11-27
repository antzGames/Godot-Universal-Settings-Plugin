extends Resource
class_name SettingsDataResource

# This file defines the structure of the settings save file.
# It containes the variables needed to persist and more importantly,
# sets the DEFAULT settings the first time your game is run.

@export var monitor_number : int  = 0


# dictionaries for options dropdowns
@export var window_modes : Dictionary = {"Window" : DisplayServer.WINDOW_MODE_WINDOWED, # this has to be first
										 "Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN}
# "Window"     : DisplayServer.WINDOW_MODE_WINDOWED				> index=0, value=0, MUST BE FIRST AND PRESENT
# "Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN > index=1, value=4
# The following is the default window mode. This will override any project settings.
@export var window_mode : int = 0		# use value
@export var window_mode_index : int = 0 # use index



# You can modify these window resolutions to your liking, 
# but there has to be at least ONE entry
@export var resolutions : Dictionary = {"1280x720"  :  Vector2i(1280, 720),  # index 0
										"1440x810"  :  Vector2i(1440, 810),  # index 1
										"1600x900"  :  Vector2i(1600, 900),  # index 2
										"1920x1080" :  Vector2i(1920, 1080)} # index 3
# The following is the default window resolution. This will override any project settings.
@export var resolution : Vector2i
@export var resolution_index : int = 1 # select index in the resolutions dictionary to default to



# MSAA: set both value and index the same.
@export var msaa_modes : Dictionary =  {"None": Viewport.MSAA_DISABLED, # index/value = 0
										"2x" : Viewport.MSAA_2X,		# index/value = 1
										"4x" : Viewport.MSAA_4X,		# index/value = 2
										"8x" : Viewport.MSAA_8X}		# index/value = 3
@export var msaa_3d : int = 2        # default MSAA set to 4X
@export var msaa_3d_index : int = 2  # default MSAA set to 4X



@export var fsr_modes : Dictionary =  { "Bilinear": Viewport.SCALING_3D_MODE_BILINEAR,
										"FSR 1.0": Viewport.SCALING_3D_MODE_FSR,
										"FSR 2.2": Viewport.SCALING_3D_MODE_FSR2}
# 3D Scaling mode: set both value and index the same
# 0 = Bilinear, 1 = FSR 1.0, 2 = FSR 2.2
@export var fsr_mode : int = 0       # default is Bilinear
@export var fsr_mode_index : int = 0 # default is Bilinear



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
