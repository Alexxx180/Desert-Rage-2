extends TextureRect

const MAX: float = 0.95

func set_value(points: Node) -> void:
	var value: float = MAX - MAX * points.points / points.maximum
	texture.fill_from.y = value
	# visible = value < MAX
