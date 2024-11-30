extends Node
class_name EnemyManager

var current_room: WalkerRoom
var rooms: Array
var enemey_counter: int = 0
@export var skeleton_scene: PackedScene

signal spawn_ladder(room)

func _ready() -> void:
	owner.connect("room_shapes_generated", Callable(_on_world_room_shapes_generated))

func _on_world_room_shapes_generated(_rooms):
	self.rooms = _rooms
	await %LoadTimer.timeout
	for r : WalkerRoom in rooms:
		if r.is_starting_room:
			continue
		var skelton_number = randi_range(Globals.difficulty, Globals.difficulty * 2)
		r.connect("player_entered_room", Callable(_on_player_enterd_room))
		for i in skelton_number:
			enemey_counter += 1
			randomize()
			var skeleton_instance = skeleton_scene.instantiate()
			var rand_pos = Globals.find_random_position(r.room_size)
			skeleton_instance.position = rand_pos
			r.add_child(skeleton_instance)
			skeleton_instance.connect("died", Callable(_on_enemy_died))
	


func _on_enemy_died():
	enemey_counter -= 1
	print(enemey_counter)
	if enemey_counter <= 0:
		spawn_ladder.emit(current_room)
	

func _on_player_enterd_room(_room):
	current_room = _room
	
