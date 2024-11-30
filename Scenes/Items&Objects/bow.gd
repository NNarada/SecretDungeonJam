extends Node2D
class_name Bow

@onready var arrow_scene: PackedScene = preload("res://Scenes/Items&Objects/arrow.tscn")
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_timer: Timer = $ShootingTimer
@export var arrow_roation_marker: Marker2D

var can_attack: bool = true
var disabled = false


func _input(_event):
	if disabled:
		return
	if(Input.is_action_just_pressed("left_click_attack") and can_attack):
		AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_BOW_SHOOT)
		play_bow_animation()
		can_attack = false
		shooting_timer.start()
		var arrow_instance = arrow_scene.instantiate()
		arrow_instance.position = global_position
		arrow_instance.rotation = arrow_roation_marker.rotation
		owner.owner.add_child(arrow_instance)


func play_bow_animation() -> void:
	animator.play("attack")


func _on_shooting_timer_timeout():
	shooting_timer.wait_time = 1
	can_attack = true
