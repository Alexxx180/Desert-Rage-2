extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

func _ready() -> void: helping()

func equipment(slots: Array, item: Dictionary) -> void:
	workspace.stack.equipment(slots, item)

func production(slots: Array) -> void: workspace.stack.production(slots)
func describe(item: Dictionary) -> void: workspace.stack.set_item(item)

func put_product(item: Dictionary) -> void: slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()
