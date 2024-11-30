extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var borders: Rect2 = Rect2()
var step_history: Array = []
var steps_since_turn: int = 0
var rooms: Array = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps) -> Array:
	place_room(position)
	for s in steps:
		if steps_since_turn >= 8:
			change_direction()
		
		if step():
			step_history.append(position)
			step_history.append(position + Vector2(-1, -1))
			step_history.append(position + Vector2(-1, 0))
			step_history.append(position + Vector2(0, -1))
			step_history.append(position + Vector2(-1, 1))
			step_history.append(position + Vector2(0, 1))
			step_history.append(position + Vector2(1, 1))
			step_history.append(position + Vector2(1, 0))
			step_history.append(position + Vector2(1, -1))
		else:
			change_direction()
	return step_history


func step() -> bool:
	var target_position = position + 2 * direction
	if borders.has_point(target_position + Vector2(-1, -1)) or borders.has_point(target_position + Vector2(1, 1)):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false


func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()


func place_room(pos):
	var size = Vector2(randi() % 7 + 6, randi() % 7 + 6)
	var top_left_corner = (pos - size/2).ceil()
	var add_room = true
	for r in rooms:
		if r.position == pos:
			if(get_room_area(r.size) < get_room_area(size)):
				rooms.erase(r)
			else:
				add_room = false
			break
			
	if add_room:
		rooms.append(create_room(pos, size))
		
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			step_history.append(new_step)


func get_room_area(vec: Vector2)-> int:
	return int(vec.x * vec.y)


func create_room(pos, s):
	return {position = pos, size = s}


func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
