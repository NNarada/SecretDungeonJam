extends CanvasLayer
class_name TextBox

const CHAR_READ_RATE = 0.05
@onready var texbox_container = %MarginContainer
@onready var start_symbol = $MarginContainer/MarginContainer/HBoxContainer/Start
@onready var label = $MarginContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol = $MarginContainer/MarginContainer/HBoxContainer/End


enum State{
	READY,
	READING,
	FINISHED
}

var player_near_npc: bool = false
var current_text: String = ""
var text_queue = []
var current_state: State = State.READY

func _ready():
	hide_textbox()
	queue_text("The skeltons are holding your secret son. Here, take this bow and sword and you'll thank me later.")
	queue_text("Figuer out how to swap between them on your own...")
	queue_text("Kill them all!")


func _process(delta):
	if player_near_npc:
		show_textbox()
		match current_state:
			State.READY:
				if !text_queue.is_empty():
					display_text()
			State.READING:
				if Input.is_action_just_pressed("next_text"):
					label.visible_ratio = 1.0
					end_symbol.text = "E"
					change_state(State.FINISHED)
			State.FINISHED:
				if Input.is_action_just_pressed("next_text"):
					change_state(State.READY)
					#hide_textbox()
	else:
		hide_textbox()
		

func hide_textbox() -> void:
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	texbox_container.hide()

func queue_text(next_text):
	text_queue.push_back(next_text)

func show_textbox() -> void:
	start_symbol.text = "*"
	label.text = current_text
	end_symbol.text = "E"
	texbox_container.show()

func display_text() -> void:
	var next_text = text_queue.pop_front()
	current_text = next_text
	label.text = next_text
	label.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, len(next_text) * CHAR_READ_RATE)
	tween.finished.connect(on_tween_finished)
	

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass
		State.READING:
			pass
		State.FINISHED:
			pass


func on_tween_finished():
	end_symbol.text = "E"
	change_state(State.FINISHED)
