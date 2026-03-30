extends Label

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	text = "" if next == BOUNDARY else str(next)
