extends Area2D
class_name WalkerRoom

var room_size: Vector2
var room_vertices: Array = []
var room_area: Rect2
var is_starting_room = false
var load_timer = true

signal player_entered_room(room: WalkerRoom)

func make_room(pos: Vector2, size: Vector2):
	position = pos
	room_size = size
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.extents = room_size
	$CollisionShape2D.shape = rect
	set_rect_vertices()
	set_area()
	

func set_area():
	if(room_vertices):
		room_area = Rect2(room_vertices[0].x, room_vertices[0].y, room_vertices[3].x, room_vertices[3].y)
		
func set_rect_vertices():
	var half_room_size = room_size / 2
	#Top left
	room_vertices.append(Vector2(position.x - half_room_size.x, position.y - half_room_size.y))
	#Top Right
	room_vertices.append(Vector2(position.x + half_room_size.x, position.y - half_room_size.y))
	#Bottom left
	room_vertices.append(Vector2(position.x - half_room_size.x, position.y + half_room_size.y))
	#Bottom Right 
	room_vertices.append(Vector2(position.x + half_room_size.x, position.y + half_room_size.y))


func _on_area_entered(area):
	pass
	#if(area is WalkerRoom):
		#get_tree().reload_current_scene()
		
func _on_body_entered(body):
	if(body is Player):
		if load_timer:
			is_starting_room = true
			print("is starting room")
		print("player enetered room")
		player_entered_room.emit(self)


func _on_load_timer_timeout():
	load_timer = false
