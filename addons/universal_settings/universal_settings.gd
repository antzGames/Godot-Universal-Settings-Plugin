@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("UniversalSettings", "res://addons/universal_settings/scenes/universal_settings_menu.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("UniversalSettings",)
