extends HFlowContainer

@onready var ray: MarginContainer = $ray
@onready var rock: MarginContainer = $rock
@onready var selection: Array[Dictionary] = [get_cursor(), get_cursor()]

func get_cursor() -> Dictionary:
	return { "bag": Defaults.NODE, "slot": Defaults.INT }

func _ready() -> void:
	for hero in ["ray", "rock"]:
		get(hero).items.connect_selection(selection)
