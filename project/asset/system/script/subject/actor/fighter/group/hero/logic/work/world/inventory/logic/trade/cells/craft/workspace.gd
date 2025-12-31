extends Node

func update_ui(logic: Node, preview: Node, slots: Array) -> void:
	var ui: Node = logic.items.ui
	ui.set_resource(logic.trade)
	if preview.slots(logic, slots):
		ui.put_product(logic.item(preview.craft_id).item)

func one_item() -> void: pass
func one_slot() -> void: pass
