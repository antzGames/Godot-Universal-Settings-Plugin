extends VBoxContainer

const VOLUME_SLIDER = preload("uid://bbed87snykmws")
@onready var universal_settings_menu: ColorRect = $"../../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	
	for i in AudioServer.bus_count:
		var new_slider : VolumeSlider = VOLUME_SLIDER.instantiate()
		add_child(new_slider)
		if i == 4: break  # only support 4 buses + master = 5 total

func _on_load_settings():
	for i in AudioServer.bus_count:
		var new_slider: VolumeSlider = get_child(i) as VolumeSlider
		new_slider.bus_index = i
		new_slider.bus_name = AudioServer.get_bus_name(i)
		
		new_slider.vol_slider.value_changed.connect(new_slider._on_value_changed)
		new_slider.vol_slider.value = db_to_linear(AudioServer.get_bus_volume_db(new_slider.bus_index))
		new_slider.percent = new_slider.vol_slider.value * 100.0
		new_slider.label.text = str(new_slider.bus_name, " Volume:")
		new_slider.percent_label.text = str(new_slider.percent, "%")

		match new_slider.bus_index:
			0: 
				new_slider.vol_slider.value = universal_settings_menu.settings_data.master_volume
			1: 
				new_slider.vol_slider.value = universal_settings_menu.settings_data.music_volume
			2: 
				new_slider.vol_slider.value = universal_settings_menu.settings_data.sfx_volume
			3: 
				new_slider.vol_slider.value = universal_settings_menu.settings_data.voice_volume
			4: 
				new_slider.vol_slider.value = universal_settings_menu.settings_data.other_volume
				break
		
func save_volumes_levels():
	for i in AudioServer.bus_count:
		var new_slider: VolumeSlider = get_child(i) as VolumeSlider
		match new_slider.bus_index:
			0: 
				universal_settings_menu.settings_data.master_volume = new_slider.vol_slider.value
			1: 
				universal_settings_menu.settings_data.music_volume = new_slider.vol_slider.value
			2: 
				universal_settings_menu.settings_data.sfx_volume = new_slider.vol_slider.value
			3: 
				universal_settings_menu.settings_data.voice_volume = new_slider.vol_slider.value
			4: 
				universal_settings_menu.settings_data.other_volume = new_slider.vol_slider.value
