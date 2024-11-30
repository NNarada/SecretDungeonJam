extends Camera2D
class_name PlayerCamera

@export var random_strength_shake: float = 6.0
@export var shake_fade: float = 3

var shake_strength: float = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offeset()

func apply_shake():
	shake_strength = random_strength_shake
	
func random_offeset() -> Vector2:
	return Vector2(Globals.rng.randf_range(-shake_strength, shake_strength), Globals.rng.randf_range(-shake_strength, shake_strength))
