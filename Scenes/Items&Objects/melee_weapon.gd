extends Node2D
class_name MeleeWeapon

var weapon: AllWeapons = AllWeapons.new()
var distance_from_player: int = 10
var can_attack: bool = true
var hit_box_collision_shape: CollisionShape2D
var disabled = true

func _ready() -> void:
	hit_box_collision_shape = %CollisionShape2D
	#hit_box_collision_shape.disabled = true
	update_weapon()

func _process(_delta):
	#disable the weapn if we are aming at a wall
	
	if($RayCast2D.get_collider_rid()):
		$Sprite2D.hide()
		$Sprite2D/HitBoxComponent/CollisionShape2D.disabled = true
	else:
		$Sprite2D.show()
		#$Sprite2D/HitBoxComponent/CollisionShape2D.disabled = false
	
func rotate_sword(degrees: int, time: float) -> void:
	var tween: Tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "rotation", deg_to_rad(degrees), time).from_current()
	await get_tree().create_timer(time).timeout

func _input(_event):
	if disabled:
		return
	#Play the Melee attack animation
	if(Input.is_action_just_pressed("left_click_attack") and can_attack):
		can_attack = false
		await rotate_sword(-25, 0.2)
		hit_box_collision_shape.disabled = false
		await rotate_sword(45, 0.05)
		await rotate_sword(0, 0.05)
		hit_box_collision_shape.disabled = true
		can_attack= true
	if(Input.is_action_just_pressed("right_click_attack") and can_attack):
		can_attack = false
		await rotate_sword(25, 0.2)
		hit_box_collision_shape.disabled = false
		await rotate_sword(-45, 0.05)
		await rotate_sword(0, 0.05)
		hit_box_collision_shape.disabled = true
		can_attack= true
#	if(Input.is_action_just_pressed("click attack")):
#		$Sprite2D.texture = Weapon.anime_sword.weapon_texture
#		update()


func update_weapon() -> void:
	#Keep the melee weapon away from the player by some distance
	$Sprite2D.position.x = ($Sprite2D.texture.get_height()/2) + distance_from_player
	
	#Postion the raycast target to the tip of the melee weapon
	$RayCast2D.target_position.x = $Sprite2D.texture.get_height() + distance_from_player
	
	#Resize the hitbox of the melee weapon based on if it is a sword or something else
#	if(Weapon)
	#$Sprite2D/HitBoxComponent/CollisionShape2D.shape.height = $Sprite2D.texture.get_height()
	
	#Set the damage of the weapon to thehitbox
	%HitBoxComponent.damage = weapon.anime_sword.damage
