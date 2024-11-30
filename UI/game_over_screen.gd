extends Control

@onready var play_again_button: Button = %PlayAgainButton
@onready var quit_button: Button = %QuitButton

func _ready():
	play_again_button.button_down.connect(Callable(self, "on_play_button_pressed"))
	quit_button.button_down.connect(Callable(self, "on_quit_button_pressed"))


func on_play_button_pressed() -> void:
	hide()
	Globals.difficulty = 1
	Globals.skeltons_killed_counter = 0
	get_tree().reload_current_scene()


func on_quit_button_pressed() -> void:
	get_tree().quit()
