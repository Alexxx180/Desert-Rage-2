extends Node2D

@onready var fight: Node2D = $fight
@onready var path: Node2D = $path

func _ready() -> void:
	fight.hitbox.health.freeze.connect(path.target.temporary_freeze)
	fight.hitbox.health.dead.connect(func(): path.target.hit.stop())
