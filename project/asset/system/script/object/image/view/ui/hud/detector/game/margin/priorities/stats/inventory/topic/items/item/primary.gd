extends InventoryItem

@onready var color: ColorRect = $margin/selection/fast/color
@onready var back: TextureRect = $margin/selection/fast/back

func _toggle(state: bool) -> void: # progress color: #999999
	color.visible = state
	back.visible = state

func show_selection() -> void: _toggle(true)
func hide_selection() -> void: _toggle(false)

@onready var bar: ProgressBar = $bar
@onready var number: Label = $number

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	show()
	if next == BOUNDARY:
		remove_item()
	else:
		set_values(str(next), next)

func set_values(label: String, next: int) -> void:
	number.text = label
	bar.value = next

func remove_item() -> void: set_values("", 0)

func set_value(next: int) -> void:
	show()
	if next == BOUNDARY:
		remove_item()
	else:
		set_values(str(next), next)
