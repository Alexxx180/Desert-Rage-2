extends Area2D

@export var direction: int = 1

@onready var levels: Node = $levels
@onready var interval: Node = $interval

func _finish(_hero: CharacterBody2D) -> void:
	Session.location["level"].x += direction
	Session.location["level"].y = interval.part

	var path: String = levels.complete_path()

	assert(ResourceLoader.exists(path))
	get_tree().call_deferred("change_scene_to_file", path)

func _ready() -> void:
	var level: Vector2i = Session.location["level"]
	interval.set_stairs_position(level.y, position)
