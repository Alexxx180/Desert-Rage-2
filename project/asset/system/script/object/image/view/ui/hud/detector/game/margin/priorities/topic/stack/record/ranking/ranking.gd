extends HFlowContainer

@onready var selection: VBoxContainer = $selection
@onready var rank: Label = $rank

var status: VBoxContainer

func calculate_rank() -> void:
	pass # implement based on enemy and hero stats
