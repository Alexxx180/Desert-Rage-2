extends SubViewport

@onready var player: CharacterBody2D = get_node("../../../../../group/ray")
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	world_2d = get_tree().root.world_2d
	
func _physics_process(delta: float) -> void:
	camera.position = player.position
