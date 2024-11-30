extends Control
class_name MainMenu


@onready var play_button = %PlayButton as Button
#@onready var settings_button = %SettingsButton as Button
@onready var quit_button = %QuitButton as Button
@onready var start_level = preload("res://WorldGeneration/world.tscn")


func _ready():
	play_button.button_down.connect(on_play_button_down)
	#settings_button.button_down.connnect(on_settings_button_down)
	quit_button.button_down.connect(on_quit_button_down)
	

func on_play_button_down() -> void:
	get_tree().change_scene_to_packed(start_level)


func on_settings_button_down() -> void:
	pass


func on_quit_button_down() -> void:
	get_tree().quit()
