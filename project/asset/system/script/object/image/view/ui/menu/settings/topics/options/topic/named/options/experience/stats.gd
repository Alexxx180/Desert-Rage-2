extends VBoxContainer

@onready var options: HFlowContainer = $content/options

func get_items() -> Array[Control]:
	return [$header]
