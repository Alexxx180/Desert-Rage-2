extends Button

@onready var stand: VBoxContainer = $content
@onready var collapsed: Control = stand.get_node("collapsed")
@onready var selected: Control = stand.get_node("selected")
@onready var preview: Control = stand.get_node("selected/image")

func toggle(selection: bool) -> void:
	collapsed.visible = !selection
	selected.visible = selection

func hide_item() -> void:
	toggle(false)
	preview.hide()

func _ready() -> void:
	mouse_entered.connect(func(): stand.show())
	mouse_exited.connect(func(): stand.hide())

func show_item() -> void:
	toggle(true)
	preview.show()
