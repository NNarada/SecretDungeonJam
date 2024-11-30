class_name Weapon
extends Resource

var ID: int
var damage: int
var is_sword: bool
var weapon_texture: Texture2D

func _init(id: int, dmg: int, sword: bool, texture: Texture2D) -> void:
	ID = id
	damage = dmg
	is_sword = sword
	weapon_texture = texture
