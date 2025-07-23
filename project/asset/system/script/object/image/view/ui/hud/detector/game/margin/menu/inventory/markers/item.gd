extends VBoxContainer

@onready var collapsed: Control = $collapsed
@onready var selected: Control = $selected
@onready var preview: Control = $selected/margin

func toggle(selection: bool) -> void:
	collapsed.visible = !selection
	selected.visible = selection

func hide_item() -> void:
	toggle(false)
	preview.hide()

func show_item() -> void:
	toggle(true)
	preview.show()
