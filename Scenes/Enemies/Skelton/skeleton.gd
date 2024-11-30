extends CharacterBody2D

var speed: float = 70
@export var nav_agent: NavigationAgent2D


var target_node = null
var home_pos = Vector2.ZERO
var sprite_animator: AnimatedSprite2D
var animation_player: AnimationPlayer
var hit_audio = AudioStreamPlayer2D
var new_velocity: Vector2
var is_dead: bool = false
var hit_sound_effect_flag: bool = false  
var pushback_force := Vector2.ZERO
var weapon_sprite: Sprite2D
var weapon_collision_shape: CollisionShape2D
var weapon_center: Marker2D

signal died

func _ready():
	speed += Globals.difficulty * 5
	home_pos = self.global_position
	%HurtBoxComponent.entity_hurt.connect(_on_hurt_box_entity_hurt)
	nav_agent.path_desired_distance = 17
	nav_agent.target_desired_distance = 17
	sprite_animator = %AnimatedSprite2D
	animation_player = %AnimationPlayer
	weapon_sprite = %WeaponSprite2D
	weapon_collision_shape = %WeaponCollisionShape2D
	weapon_center = %WeaponCenter

func _process(delta):
	weapon_center.look_at(Globals.player_global_position)
	weapon_center.rotate(PI/2)
	if is_dead:
		return
	if(abs(velocity.x) > 0 or abs(velocity.y) > 0):
		sprite_animator.play("Moving")
	else:
		sprite_animator.play("Idel")
	if(target_node and is_instance_valid(target_node)):
		if global_position.x < target_node.global_position.x:
			sprite_animator.flip_h = false 
		else:
			sprite_animator.flip_h = true
		#sprite_animator.flip_h = false if global_position.x < target_node.global_position.x else true
	#attack the player if you the skelton is within range
	if global_position.distance_to(Globals.player_global_position) < 35:
		attack()
	else:
		hide_weapon()


func _physics_process(delta) -> void:
	if is_dead:
		return 
	move_and_slide()
	
	#If the enemy is hitwe want to use the velocity pf knock back
	if nav_agent.is_navigation_finished():
		return
	var directon = to_local(nav_agent.get_next_path_position()).normalized()
	new_velocity = directon * speed
	
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		velocity = new_velocity

func recalc_path():
	if !is_instance_valid(target_node):
		return
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos


func knock_back(source_position: Vector2) -> void:
	pushback_force = global_position.direction_to(source_position) * 200
	velocity = lerp(pushback_force, Vector2.ZERO, 5)


func attack():
	if !is_instance_valid(target_node):
		weapon_sprite.visible = false
		weapon_collision_shape.disabled = true
		return
	weapon_sprite.visible = true
	if !animation_player.is_playing():
		animation_player.play("weapon_attack")
	
func hide_weapon():
	weapon_sprite.visible = false
	weapon_collision_shape.disabled = true


func _on_health_component_entity_is_dead() -> void:
	if is_dead:
		return
	sprite_animator.play("Death")
	%DeadCorpsTimer.start()
	is_dead = true
	Globals.skeltons_killed_counter += 1
	died.emit()




func _on_recalculate_timer_timeout():
	recalc_path()


func _on_agro_range_area_entered(area):
	if is_instance_valid(area):
		target_node = area.owner
	else:
		target_node = null


func _on_deagro_range_area_exited(area):
	if area.owner == target_node:
		target_node = null


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_hurt_box_entity_hurt():
	if is_dead:
		if !hit_sound_effect_flag:
			hit_sound_effect_flag = true
			AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SKELTON_HIT)
		return
	target_node = Globals.player_instance
	self.animation_player.play("hit")
	AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SKELTON_HIT)

func _on_dead_corps_timer_timeout():
	queue_free()
