extends CharacterBody2D



@export var text_box: TextBox

func _ready():
	if Globals.difficulty > 1:
		queue_free()


func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	text_box.player_near_npc = true


func _on_area_2d_area_exited(area):
	text_box.player_near_npc = false
