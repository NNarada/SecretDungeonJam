extends Node

var player_global_position: Vector2
var player_instance: Player
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var difficulty: int = 1
var skeltons_killed_counter: int = 0:
	set(value):
		skeltons_killed_counter = value
		skelton_counter_changed.emit()

signal skelton_counter_changed 

func find_random_position(size: Vector2) -> Vector2:
	var cord = randi_range(1, 4)
	var rand_x = 0
	var rand_y = 0
	match cord:
		1:
			@warning_ignore("narrowing_conversion")
			rand_x = randi_range(-size.x/2, 0)
			@warning_ignore("narrowing_conversion")
			rand_y = randi_range(-size.y/2, 0)
		2:
			@warning_ignore("narrowing_conversion")
			rand_x = randi_range(0, size.x/2)
			@warning_ignore("narrowing_conversion")
			rand_y = randi_range(-size.y/2, 0)
		3:
			@warning_ignore("narrowing_conversion")
			rand_x = randi_range(-size.x/2, 0)
			@warning_ignore("narrowing_conversion")
			rand_y = randi_range(0, size.y/2)
		4:
			@warning_ignore("narrowing_conversion")
			rand_x = randi_range(0, size.x/2)
			@warning_ignore("narrowing_conversion")
			rand_y = randi_range(0, size.y/2)
	return Vector2(rand_x, rand_y)
