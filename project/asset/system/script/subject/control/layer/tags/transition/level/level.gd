extends Node

signal next_level(path: String, fdiff: int)

func connect_levels(curtain: CanvasLayer) -> void:
	next_level.connect(curtain.start_transition)
	# Stop transitions
	# next_level.connect(check.next_level_transition)

func credits() -> void: next_level.emit(Defaults.now.credits, 0) ; print("CREDITS")

func elevate(lay: Node) -> void:
	var diff: int = lay.border.extract(Tile.FLOOR)
	var part: int = lay.tags.logic_no
	# if tiles.link.name != "none": part = Tile.logic_no(tiles.link.atlas) # var F: String = floors.get_next(diff)
	var F: String = SessionStats.group_level(diff)

	var caption: String = SessionStats.location.name
	next_level.emit(Defaults.now.level % [caption, F, part], diff)
