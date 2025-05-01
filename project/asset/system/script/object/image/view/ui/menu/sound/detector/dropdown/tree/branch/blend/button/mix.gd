extends Button

@onready var caption: VBoxContainer = $margin/caption
@onready var slider: VSlider = get_node("../../../mix")

func _ready() -> void:
	slider.value_changed.connect(set_metadata)
	
func _toggled(toggled_on: bool) -> void:
	slider.visible = toggled_on

func set_metadata(mix: int) -> void:
	caption.status.text = str(mix)
