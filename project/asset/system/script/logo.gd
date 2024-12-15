extends ColorRect

@onready var player = $player
@export var scene: String = "res://assets/systems/scenes/levels/caves/origin/0/0/level.tscn"

func _ready():
	await get_tree().create_timer(1).timeout
	player.play("logo/appear")
	await get_tree().create_timer(3).timeout
	player.play_backwards("logo/appear")
	await get_tree().create_timer(1).timeout
	print_debug(get_tree().change_scene_to_file(scene))
