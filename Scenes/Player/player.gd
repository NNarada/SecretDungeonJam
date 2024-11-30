extends CharacterBody2D
class_name Player

@onready var health_component: HealthComponent = $HealthComponent
@onready var player_camera: PlayerCamera = %Camera2D
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var dash_duration: Timer = %DashDuration
@onready var melee_weapon: MeleeWeapon = %MeleeWeapon
@onready var bow: Bow = %Bow

@export var game_over_screen: Control 

var current_player_speed: int = 70
var walk_speed: int = 75
var dash_speed: int = 300
var move_direction: Vector2
var facing_right: bool = true
var can_attack: bool = true
var can_dash: bool = true

signal player_health_changed

func _ready():
	Globals.player_instance = self
		
func _process(_delta):
 	#make the player run backward if they are facing one way and moving the other direction
	if(facing_right):
		if(velocity == Vector2.ZERO):
			$AnimatedSprite2D.play("Idel")
		if(abs(velocity.y) > 0):
			$AnimatedSprite2D.play("Run")
		if(velocity.x > 0):
			$AnimatedSprite2D.play("Run")
		elif(velocity.x < 0):
			$AnimatedSprite2D.play_backwards("Run")
	else:
		if(velocity == Vector2.ZERO):
			$AnimatedSprite2D.play("Idel")
		if(abs(velocity.y) > 0):
			$AnimatedSprite2D.play("Run")
		if(velocity.x > 0):
			$AnimatedSprite2D.play_backwards("Run")
		elif(velocity.x < 0): 
			$AnimatedSprite2D.play("Run")
	if velocity != Vector2.ZERO:
			AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_PLAYER_STEP)
			
func _physics_process(delta):
	Globals.player_global_position = global_position
	velocity = current_player_speed * move_direction	
	move_and_slide()
	
func _input(event):
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$PlayerCenter.look_at((get_global_mouse_position()))
	#Figur out where the mouse is and make the player face the direction of the side the mouse is on
	if(get_global_mouse_position().x < position.x):
		$AnimatedSprite2D.scale.x = -1
		facing_right = false
	else:
		facing_right = true
		$AnimatedSprite2D.scale.x = 1
	if event.is_action_pressed("dash") and can_dash:
		dash()
		can_dash = false
	
	if event.is_action_pressed("swap_weapon"):
		if bow.disabled:
			bow.disabled = false
			bow.show()
			melee_weapon.disabled = true
			melee_weapon.hide()
		else:
			bow.disabled = true
			bow.hide()
			melee_weapon.disabled = false
			melee_weapon.show()
			

func dash():
	current_player_speed = dash_speed
	dash_duration.start()
	dash_cooldown_timer.start()


func get_health() -> int:
	return health_component.health

func _on_weapon_hit_box_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area_rid)



func _on_agroing_area_area_entered(area):
	#if area is WalkerRoom:
		pass
		#print("player entered room")


func _on_player_area_2d_area_entered(area):
	if area is WalkerRoom:
		pass
		#print("Player script: player eneterd room")


func _on_health_component_health_changed():
	pass


func _on_hurt_box_component_entity_hurt():
	if health_component:
		if health_component.health == 0:
			queue_free()
			game_over_screen.visible = true
	player_health_changed.emit()
	AudioManager.create_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_PLAYER_HIT)
	player_camera.apply_shake()


func _on_dash_cooldown_timer_timeout():
	can_dash = true
	


func _on_dash_duration_timeout():
	current_player_speed = walk_speed
