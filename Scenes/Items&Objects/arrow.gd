extends Node2D


var speed = 200
var arrow_damage = 10


func _ready():
	%HitBoxComponent.damage = arrow_damage

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta



func _on_hit_box_component_area_entered(area):
	if !(area is HurtBoxComponent):
		return
	var hitbox = area as HurtBoxComponent
	if hitbox.type == HurtBoxComponent.TYPE.ENEMY:
		queue_free()




func _on_tilemap_collision_area_2d_body_entered(body):
	queue_free()
