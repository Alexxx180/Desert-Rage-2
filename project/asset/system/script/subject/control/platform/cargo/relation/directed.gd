extends Node

@onready var timer: Timer = $timer
var _platform: CharacterBody2D

func bind_lever() -> void:
	var tags: TileMapLayer = _platform.get_node("../tags")
	var location: Node = tags.lockers.location
	var pos: Vector2 = _platform.position + _platform.see.position
	var data: Dictionary = location.search.atlas.get_mech_atlas(tags.lay.tags, pos)
	data.processor = _platform.work
	location.storage.setup_mech(data)

func controls(platform: CharacterBody2D) -> void:
	#TODOT CARGO CONNECT
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work
	#bind_lever(platform)
	_platform = platform

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.timeout.connect(bind_lever)
	timer.start()
	work.timer.timeout.connect(work.enable_control)
