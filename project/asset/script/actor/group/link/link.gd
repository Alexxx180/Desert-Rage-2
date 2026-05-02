extends Node

@onready var location: Node = $location
@onready var ability: Node = $ability

# bit-field: casual_mode

func connect_books(cells: Array[Vector2i]) -> void: pass
func connect_chests(cells: Array[Vector2i]) -> void:
	# chests.group = self
	pass
func connect_transition(cells: Array[Vector2i]) -> void: pass
func connect_chats(cells: Array[Vector2i]) -> void: pass
func connect_logic(cells: Array[Vector2i]) -> void:
	# lockers.location.activator.trigger.chests = chests
	pass
 
func connect_any(root: LevelRoot, connector: String, id: int) -> void:
	var cells: Array[Vector2i] = root.execute.busy(Def.VECTI, id)
	if cells.size() > 0: get("connect_" + connector).call(cells)

func setup(root: LevelRoot) -> void:
	root.group.work.lockers.root = root
	if !root.execute.is_enabled: return
	
	for i in LevelRoot.items(): connect_any(root, i[0], i[1])
	# if not casual_mode:
	connect_any(root, "enemy", LevelRoot.ENEMY)
