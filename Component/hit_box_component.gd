class_name HitBoxComponent
extends Area2D

enum TYPE{
	PLAYER,
	ENEMY
}
@export var type: TYPE
@export var damage: int
@export var should_knock_back: bool = false

func _init():
	collision_layer = 256
	collision_mask = 512
