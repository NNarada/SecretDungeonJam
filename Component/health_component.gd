class_name HealthComponent 
extends Node2D

@export var max_health: int
signal entity_is_dead
signal health_changed

var health: int = 0:
	set(value):
		health_changed.emit()
		if(value - health < 0):
			health = max(0, value)
		else:
			health = min(value, max_health)
		if(health <= 0):
			entity_is_dead.emit()

func _ready() -> void:
	health = max_health
	
func take_damage(amount: int) -> void:
	print("took dmg")
	health -= amount 
