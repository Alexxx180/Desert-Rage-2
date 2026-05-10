class_name GroupWork extends Node

const MANUAL: int = 1

var dialog: Label:
	get: return Works.pload(self, PreloadBus.dialog, "dialog")

func show_text(map_coords: Vector2i) -> void:
	var books: Dictionary = {}
	dialog.position = map_to_local(map_coords + Vector2i(-3, -3))
	dialog.set_text(books[map_coords][MANUAL])
	dialog.show()

func hide_text() -> void: dialog.hide()

func update_act(caption: String) -> Node: return Works.uploads(self, LoadBus.group % caption, caption)

var _stats: MakeStats
var stats: MakeStats:
	get:
		if _stats == null: _stats = MakeStats.new(Works.pload(self, PreloadBus.multiply, "multiply"))
		return _stats

var root: LevelRoot

var lockers: Node:
	get: return update_act("lockers")
var books: Node:
	get: return update_act("books")
var chests: Node:
	get: return update_act("chests")
var enemy: Node:
	get: return update_act("enemy")
var transition: Node:
	get: return update_act("transition")

@onready var xp: Node = $xp
# @onready var push: TileMapLayer = get_node("../push")

# bit-field: casual_mode

func connect_books(cells: Array[Vector2i]) -> void: pass
func connect_chests(cells: Array[Vector2i]) -> void: pass # chests.group = self
func connect_transition(cells: Array[Vector2i]) -> void: pass
func connect_chats(cells: Array[Vector2i]) -> void: pass
func connect_logic(cells: Array[Vector2i]) -> void: pass # lockers.location.activator.trigger.chests = chests
func connect_any(root: LevelRoot, connector: String, id: int) -> void:
	var cells: Array[Vector2i] = root.execute.busy(Def.VECTI, id)
	if cells.size() > 0: get("connect_" + connector).call(cells)

func setup(root: LevelRoot) -> void:
	root.group.work.lockers.root = root
	if !root.execute.is_enabled: return
	
	for i in LevelRoot.items(): connect_any(root, i[0], i[1])
	# if not casual_mode:
	connect_any(root, "enemy", LevelRoot.ENEMY)

func open_chests(hero: CharacterBody2D) -> void:
	chests.open_chests(hero)

func recovery(hero: CharacterBody2D) -> void:
	recovery.recover(hero)

func activate(pos: Vector2):
	var tile: Dictionary = root.border.from_pos(pos).context
	if tile.coords == Def.VECTI: return # print("ATLAS, P: ", tile.atlas)#, " - N: ", atlas)
	
	if chests.is_chest(tile.atlas): # TODO FIX 5 0
		return chests.open_chests()
	
	if lockers.activator.search.storage.has_trigger(tile.coords):
		return lockers.activator.activate_trigger(tile.coords)
