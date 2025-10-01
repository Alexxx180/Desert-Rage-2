extends Button

@onready var stand: PanelContainer = $stand
@onready var collapsed: Control = $stand/content/collapsed
@onready var selected: Control = $stand/content/selected
@onready var preview: Control = $stand/content/selected/image

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
