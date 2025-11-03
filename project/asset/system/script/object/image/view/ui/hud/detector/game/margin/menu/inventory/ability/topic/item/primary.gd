extends InventoryItem

@onready var color: ColorRect = $margin/selection/color
@onready var back: TextureRect = $margin/selection/back

func _toggle(state: bool) -> void:
	color.visible = state
	back.visible = state

func show_selection() -> void: _toggle(true)

func hide_selection() -> void: _toggle(false)
