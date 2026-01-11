extends Node

signal new_slot()

const MAX: int = 2

var slots: TradeSlots

@onready var preview: Node = $preview
@onready var placement: Node = $placement
@onready var workspace: Node = $workspace

func set_logic(logic: Node) -> void:
	placement.preview = preview

func add_slot(slot: int) -> void:
	slots.operate("craft", MAX, placement.make_slot(slot))
	workspace.update_ui(placement.search.logic, preview, slots.slots)

func one_item(selected: Dictionary) -> void: pass
func one_slot(selected: Dictionary) -> bool:
	
	return true

func all_items() -> void: pass

func product() -> void: placement.craft(slots.slots)
