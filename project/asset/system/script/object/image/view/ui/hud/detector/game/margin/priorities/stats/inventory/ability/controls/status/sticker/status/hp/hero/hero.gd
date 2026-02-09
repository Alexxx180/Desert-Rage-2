extends ProgressBar

@export var right: bool = false

@onready var health: MarginContainer = $health
@onready var ailments: HFlowContainer = $status/ailments

func change(hp: Node) -> void:
	value = hp.points
	health.change(hp)

func _ready() -> void:
	if right:
		var control: Control = ailments.get_node("control")
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		health.damage.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		health.status.right()
		fill_mode = FILL_END_TO_BEGIN
