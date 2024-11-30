extends CanvasLayer


var player_health: int
var player: Player
@onready var skeltons_killed_label = %SkeltonsKilledLabel
@onready var hearts_full: TextureRect = %FullHearts
@onready var skelton_counter_container = %SkeltonCounterContainer

func _ready():
	if Globals.skeltons_killed_counter > 0:
		skelton_counter_container.visible = true
	Globals.skelton_counter_changed.connect(on_skelton_counter_changed)
	skeltons_killed_label.text = str("X ", Globals.skeltons_killed_counter)
	player = get_tree().get_first_node_in_group("player") as Player
	player_health = player.get_health()
	player.player_health_changed.connect(on_player_health_changed)

func _process(delta):
	hearts_full.size.x = player_health * 18
	if player_health == 0:
		hearts_full.hide()
	else:
		hearts_full.show()


func on_player_health_changed():
	player_health = player.get_health()

func on_skelton_counter_changed():
	skelton_counter_container.visible = true
	skeltons_killed_label.text =  str("X ", Globals.skeltons_killed_counter)
	
