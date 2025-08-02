extends Node

@export var direction: Vector2 = Vector2(250, 0)

@onready var timer: Timer = $timer
@onready var cargo: Node = $cargo

const INVERSE: Vector2 = Vector2(-1, -1)

func bind_lever() -> void:
	var tags: TileMapLayer = cargo.platform.get_node("../../../tags")
	var location: Node = tags.lockers.location
	var data: Dictionary = location.search.atlas.get_mech_atlas(tags, cargo.platform.position)
	data.processor = self
	location.storage.setup_mech(data)

func move_cargo() -> void:
	cargo.move_cargo(direction)

func control_cargo() -> void:
	if not cargo.platform.detectors.ledge.sync_traps(): move_cargo()

func enable_control() -> void:
	cargo.movement = control_cargo

func toggle_logic() -> void:
	direction *= INVERSE
	cargo.movement = move_cargo
	timer.start()
