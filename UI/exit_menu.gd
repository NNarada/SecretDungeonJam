extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var controls_buttons: Button = %ControlsButton
@onready var back_button_1: Button = %BackButton1
@onready var back_button_2: Button = %BackButton2
@onready var exit_menu: MarginContainer = %ExitMenuContainer
@onready var settings_menu: MarginContainer = %SettingsMenuContainer
@onready var controls_menu: MarginContainer = %ControlsMenuContainer
@onready var volume_slider: HSlider = %VolumeSlider

var is_showing: bool = false

func _ready():
	continue_button.button_down.connect(Callable(self, "on_continue_button_pressed"))
	settings_button.button_down.connect(Callable(self, "on_settings_button_pressed"))
	quit_button.button_down.connect(Callable(self, "on_quit_button_pressed"))
	controls_buttons.button_down.connect(Callable(self, "on_controls_button_pressed"))
	back_button_1.button_down.connect(Callable(self, "on_back_button_1_pressed"))
	back_button_2.button_down.connect(Callable(self, "on_back_button_2_pressed"))
	volume_slider.value_changed.connect(Callable(self, "on_volume_slider_changed"))

func _input(event):
	if event.is_action_pressed("escape"):
		if is_showing:
			get_tree().paused = false
			controls_menu.hide()
			settings_menu.hide()
			exit_menu.show()
			hide()
			is_showing = false
		else:
			get_tree().paused = true
			show()
			is_showing = true


func on_continue_button_pressed() -> void:
	get_tree().paused = false
	is_showing = false
	hide()


func on_settings_button_pressed() -> void:
	exit_menu.hide()
	settings_menu.show()


func on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_button_1_pressed() -> void:
	exit_menu.show()
	settings_menu.hide()


func on_back_button_2_pressed() -> void:
	settings_menu.show()
	controls_menu.hide()

func on_controls_button_pressed() -> void:
	controls_menu.show()
	settings_menu.hide()

func on_volume_slider_changed(value):
	AudioServer.set_bus_volume_db(0, value)
