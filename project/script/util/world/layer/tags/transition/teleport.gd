class_name Transitions extends Node

signal next_level(path: String, fdiff: int)

func differ(layer: TileMapLayer, passage: Dictionary) -> int:
	return Tile.extract(layer, passage.coords, Tile.FLOOR)

func connect_levels(curtain: CanvasLayer) -> void:
	next_level.connect(curtain.start_transition)
	# Stop transitions
	# next_level.connect(check.next_level_transition)

func credits() -> void: next_level.emit(LoadBus.credits, 0) ; print("CREDITS")

func elevate(lay: Node) -> void:
	var diff: int = lay.border.extract(Tile.FLOOR)
	var part: int = lay.tags.logic_no
	# if tiles.link.name != "none": part = Tile.logic_no(tiles.link.atlas) # var F: String = floors.get_next(diff)
	var F: String = HUD.stats.group_level(diff)

	var caption: String = HUD.stats.location.name
	next_level.emit(LoadBus.level % [caption, F, part], diff)

var _next: bool = false
var _lay: Node

func set_layers(lay: Node) -> void: _lay = lay

func next_level_transition(_path: String, _diff: int) -> void:
	_next = true

func transitable(map: Dictionary) -> bool:
	if _next: return false
	map.link = _lay.tags.from_pos(map.pos).context

	if not map.link.name in ["none", "transition"]: return false
	map.way = _lay.execute.from_pos(map.pos).context
	return true

var teleporters: Dictionary = {} # int, Node2D

const SOURCE_ID: int = 0
const MISSING: Vector2i = Vector2i(5, 0)

func get_target(border: TileDecorator) -> Array[Vector2i]:
	return border.layer.get_used_cells_by_id(SOURCE_ID, Vector2(2, 4))

func fill(lay: Node) -> void:
	for coords in get_target(lay.border):
		var cell: Vector2i = lay.tags.atlas_coords(coords) # assert(cell != Vector2i(-1, -1), "Target is not connected!")
		teleporters[cell] = lay.tags.layer.map_to_local(coords)

func transit(hero: CharacterBody2D, lay: Node) -> void:
	var cell: Vector2i = lay.tags.context.atlas
	if teleporters.has(cell):
		hero.to.act.teleport.teleport(teleporters[cell])
	else:
		lay.border.select(MISSING).paint()
		# assert(teleporters.has(cell), "Teleporter is not connected!")

var lay: Node

func setup(_lay: Node) -> void:
	lay = _lay
	teleport.fill(lay)
	levels.connect_levels(lay.tags.layer.curtain) # check
	SessionStats.assign(lay.tags.layer.get_parent().name.trim_prefix("map"))

func transit(hero: CharacterBody2D) -> void:
	lay.tags.from_pos(hero.position)
	match lay.border.from_pos(hero.position).context.atlas:
		Vector2i(4, 0):
			teleport.transit(hero, lay) # Vector2i(2, 0), Vector2i(2, 1): #	levels.credits()
		_: levels.elevate(lay)
