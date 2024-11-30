extends Node

@export var enemy_manager: EnemyManager
@export var ladder_scene: PackedScene


signal reset_map
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_manager.spawn_ladder.connect(Callable(_on_spawn_ladder))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_ladder(room: WalkerRoom):
	var ladder_instance = ladder_scene.instantiate()
	var rand_pos = Globals.find_random_position(room.room_size)
	ladder_instance.position = rand_pos
	room.call_deferred("add_child", ladder_instance)
	ladder_instance.connect("player_enterd_ladder", Callable(on_player_entered_ladder))


func on_player_entered_ladder():
	print("ladder manager: player enterd ladder")
	reset_map.emit()
