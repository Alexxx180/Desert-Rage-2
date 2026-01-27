extends HintsCategory

func get_acts() -> Array[String]:
	return ["move", "jump", "land", "push"]

func _ready() -> void:
	$move.grab_focus()
