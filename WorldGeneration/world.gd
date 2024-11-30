extends Node2D
class_name WorldGenerator

var borders = Rect2(2, 2, 116, 62)
const TILE_SIZE: int = 16
@onready var tile_map: TileMap = $TileMap
var room_area: PackedScene = preload("res://WorldGeneration/walker_room.tscn")
var walker_map: Array = []
var rooms: Array = []
var room_collision_shapes: Array = []

signal room_shapes_generated(rooms: Array)

enum EmptyTiles {
	NONE = 0,
	TOP = 1,
	LEFT = 2,
	BOTTOM = 4,
	RIGHT = 8,
	TL_CORNER = 16,
	TR_CORNER = 32,
	BR_CORNER = 64,
	BL_CORNER = 128
}

func _ready():
	randomize()
	generate_walker_map(Vector2(58, 31))
	generate_tile_map()
	generate_room_collision_shapes()

func generate_tile_map():
	for location in walker_map:
		var random = randf_range(0, 1)
		if(random < 0.75):
			tile_map.set_cell(0 , location, 13, Vector2i.ZERO)
		else:
			tile_map.set_cell(0 , location, 10, Vector2i.ZERO)
	
	
	#Place walls / outer tile for avoiding navigation into wall
	for pos in walker_map:
		var empty_tiles: int = find_empty_tiles(pos)
		var top_wall_selector_rng = Globals.rng.randf_range(0, 1)
		var bottom_wall_selector_rng = Globals.rng.randf_range(0, 1)
		if is_top_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			if top_wall_selector_rng < 0.9:
				tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, -1), 60, Vector2i.ZERO)
				tile_map.set_cell(2, Vector2i(pos.x, pos.y) + Vector2i(0, -2), 69, Vector2i.ZERO)
			else:
				var top_wall_varation_rng = Globals.rng.randf_range(0, 1)
				if top_wall_varation_rng < 0.5:
					tile_map.set_cell(0 , pos, 56, Vector2i.ZERO)
					tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, -1), 55, Vector2i.ZERO)
					tile_map.set_cell(2, Vector2i(pos.x, pos.y) + Vector2i(0, -2), 69, Vector2i.ZERO)
				else:
					tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, -1), 57, Vector2i.ZERO)
					tile_map.set_cell(2, Vector2i(pos.x, pos.y) + Vector2i(0, -2), 69, Vector2i.ZERO)
		if is_bottom_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, 1), 60, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 69, Vector2i.ZERO)
		
		if is_bottom_left_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, 1), 59, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 28, Vector2i.ZERO)
		if is_wierd_bottom_left_corner(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, 1), 59, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 36, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 1), 66, Vector2i.ZERO)
			
		if is_bottom_right_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, 1), 67, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 29, Vector2i.ZERO)
		if is_wierd_bottom_right_corner(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y) + Vector2i(0, 1), 67, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 37, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 1), 65, Vector2i.ZERO)
			
		#Left Wall
		if is_left_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 64, Vector2i.ZERO)
		if is_top_end_left_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 31, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 1), 66, Vector2i.ZERO)
		if is_bottom_end_left_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y), 62, Vector2i.ZERO)
		
		#Rihgt Wall
		if is_right_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 63, Vector2i.ZERO)
		if is_top_end_right_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 32, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 1), 65, Vector2i.ZERO)
		if is_bottom_end_right_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y), 61, Vector2i.ZERO)
			
		if is_top_right_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y - 1), 33, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 2), 70, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 63, Vector2i.ZERO)
		if is_top_left_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y - 1), 30, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 2), 68, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y), 64, Vector2i.ZERO)
		if is_wierd_top_left_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y - 1), 30, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 2), 68, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y), 62, Vector2i.ZERO)
		if is_wierd_top_right_corner_wall(empty_tiles):
			tile_map.set_cell(0 , pos, 9, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y - 1), 33, Vector2i.ZERO)
			tile_map.set_cell(2, Vector2i(pos.x, pos.y - 2), 70, Vector2i.ZERO)
			tile_map.set_cell(1, Vector2i(pos.x, pos.y), 61, Vector2i.ZERO)

func generate_room_collision_shapes():
	for r in rooms:
		var room_a: WalkerRoom = room_area.instantiate()
		room_a.make_room(r.position * TILE_SIZE, (r.size / 2) * TILE_SIZE)
		room_collision_shapes.append(room_a)
		$Rooms.add_child(room_a)
	room_shapes_generated.emit(room_collision_shapes)

func generate_walker_map(start_pos: Vector2):
	var walker = Walker.new(start_pos, borders)
	walker_map = walker.walk(200)
	rooms = walker.rooms
	walker.queue_free()
	
func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	pass
	#if event.is_action_pressed("ui_accept"):
		#reload_level()

func find_empty_tiles(pos: Vector2) -> int:
	var empty_tiles: int = EmptyTiles.NONE
	if tile_map.get_cell_source_id(0, pos + Vector2(0, -1)) == -1:
		empty_tiles += int(EmptyTiles.TOP)
	if tile_map.get_cell_source_id(0, pos + Vector2(1, 0)) == -1:
		empty_tiles += int(EmptyTiles.RIGHT)
	if tile_map.get_cell_source_id(0, pos + Vector2(0, 1)) == -1:
		empty_tiles += int(EmptyTiles.BOTTOM)
	if tile_map.get_cell_source_id(0, pos + Vector2(-1, 0)) == -1:
		empty_tiles += int(EmptyTiles.LEFT)
	
	if tile_map.get_cell_source_id(0, pos + Vector2(-1, -1)) == -1:
		empty_tiles += EmptyTiles.TL_CORNER
	if tile_map.get_cell_source_id(0, pos + Vector2(1, -1)) == -1:
		empty_tiles += EmptyTiles.TR_CORNER
	if tile_map.get_cell_source_id(0, pos + Vector2(1, 1)) == -1:
		empty_tiles += EmptyTiles.BR_CORNER
	if tile_map.get_cell_source_id(0, pos + Vector2(-1, 1)) == -1:
		empty_tiles += EmptyTiles.BL_CORNER
	return empty_tiles

func is_top_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.TOP + EmptyTiles.TL_CORNER + EmptyTiles.TR_CORNER)
	var b = (empty_tiles == EmptyTiles.TOP + EmptyTiles.TL_CORNER)
	var c = (empty_tiles == EmptyTiles.TOP + EmptyTiles.TR_CORNER)
	var d = (empty_tiles == EmptyTiles.TOP)
	return (a || b || c || d)

func is_bottom_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.BOTTOM + EmptyTiles.BL_CORNER + EmptyTiles.BR_CORNER)
	var b = (empty_tiles == EmptyTiles.BOTTOM + EmptyTiles.BL_CORNER)
	var c = (empty_tiles == EmptyTiles.BOTTOM + EmptyTiles.BR_CORNER)
	var d = (empty_tiles == EmptyTiles.BOTTOM)
	return (a || b || c || d)

func is_bottom_left_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var b = (empty_tiles == EmptyTiles.BL_CORNER + EmptyTiles.LEFT + EmptyTiles.BOTTOM + EmptyTiles.TL_CORNER)
	var d = (empty_tiles == EmptyTiles.BL_CORNER + EmptyTiles.LEFT + EmptyTiles.BOTTOM + EmptyTiles.TL_CORNER + EmptyTiles.BR_CORNER)
	return (b || d)
	
func is_wierd_bottom_left_corner(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.BL_CORNER + EmptyTiles.LEFT + EmptyTiles.BOTTOM)
	var b = (empty_tiles == EmptyTiles.BL_CORNER + EmptyTiles.LEFT + EmptyTiles.BOTTOM + EmptyTiles.BR_CORNER)
	return (a || b)

func is_bottom_right_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.BR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BOTTOM + EmptyTiles.TR_CORNER)
	var b = (empty_tiles == EmptyTiles.BR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BOTTOM + EmptyTiles.TR_CORNER + EmptyTiles.BL_CORNER)
	return (a || b)

func is_wierd_bottom_right_corner(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.BR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BOTTOM)
	var b = (empty_tiles == EmptyTiles.BR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BOTTOM + EmptyTiles.BL_CORNER)
	return (a || b)

func is_left_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.LEFT + EmptyTiles.BL_CORNER + EmptyTiles.TL_CORNER)
	return a

func is_top_end_left_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.LEFT + EmptyTiles.BL_CORNER)
	return a

func is_bottom_end_left_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.LEFT + EmptyTiles.TL_CORNER)
	return a
	
func is_right_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.RIGHT + EmptyTiles.BR_CORNER + EmptyTiles.TR_CORNER)
	return a

func is_top_end_right_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.RIGHT + EmptyTiles.BR_CORNER)
	return a
	
func is_bottom_end_right_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.RIGHT + EmptyTiles.TR_CORNER)
	return a

func is_top_right_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.TL_CORNER + EmptyTiles.TOP + EmptyTiles.TR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BR_CORNER)
	var b = (empty_tiles == EmptyTiles.TOP + EmptyTiles.TR_CORNER + EmptyTiles.RIGHT + EmptyTiles.BR_CORNER)
	return (a || b)

func is_top_left_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.TR_CORNER + EmptyTiles.TOP + EmptyTiles.TL_CORNER + EmptyTiles.LEFT + EmptyTiles.BL_CORNER)
	var b = (empty_tiles == EmptyTiles.TOP + EmptyTiles.TL_CORNER + EmptyTiles.LEFT + EmptyTiles.BL_CORNER)
	return (a || b)

func is_wierd_top_right_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.TR_CORNER + EmptyTiles.RIGHT + EmptyTiles.TOP)
	var b = (empty_tiles == EmptyTiles.TR_CORNER + EmptyTiles.RIGHT + EmptyTiles.TOP + EmptyTiles.TL_CORNER)
	return (a || b)
	
func is_wierd_top_left_corner_wall(empty_tiles: EmptyTiles) -> bool:
	var a = (empty_tiles == EmptyTiles.TL_CORNER + EmptyTiles.LEFT + EmptyTiles.TOP)
	var b = (empty_tiles == EmptyTiles.TL_CORNER + EmptyTiles.LEFT + EmptyTiles.TOP + EmptyTiles.TR_CORNER)
	return (a || b)


func _on_ladder_manager_reset_map():
	Globals.difficulty += 1
	call_deferred("reload_level")
