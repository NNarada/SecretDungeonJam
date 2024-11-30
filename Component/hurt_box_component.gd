class_name HurtBoxComponent
extends Area2D

enum TYPE{
	PLAYER,
	ENEMY
}

@export var health_component: HealthComponent
@export var invincible_time: float
@export var type: TYPE

@onready var invincible_timer: Timer = $InvincibleTimer
@onready var invincible: bool = false


var collision_shape: CollisionShape2D
signal entity_hurt

func _init():
	collision_layer = 512
	collision_mask = 256

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	invincible_timer.wait_time = invincible_time


func _on_area_entered(hitbox: HitBoxComponent) -> void:
	if hitbox == null:
		return
	if hitbox.type != type:
		return
	if(health_component and !invincible):
		invincible_timer.start()
		invincible = true
		health_component.health -= hitbox.damage
		entity_hurt.emit()
	if owner.has_method("knock_back") and hitbox.should_knock_back:
		owner.knock_back(Globals.player_global_position)
	else:
		push_warning(owner, " Does not have HealthComponent attached to HurtBox")



func _on_invincible_timer_timeout():
	invincible = false
	invincible_timer.wait_time = invincible_time
