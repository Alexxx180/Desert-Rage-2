extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

func _ready() -> void:
	return
	helping()
	workspace.cancel.pressed.connect(select_space)

func select_space() -> void:
	slot.margin.view.drag.select_space()

func equipment(slots: Array, item: Dictionary) -> void:
	workspace.stack.equipment(slots, item)

func production(slots: Array) -> void:
	workspace.stack.production(slots)
	if slot.visible and slots.is_empty():
		slot.hide()

func describe(item: Dictionary) -> void:
	workspace.stack.set_item(item)

func put_product(item: Dictionary) -> void: slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()
