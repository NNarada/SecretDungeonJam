extends Node2D


signal player_enterd_ladder


func _ready():
	pass


func _on_area_2d_area_entered(area):
	player_enterd_ladder.emit()
