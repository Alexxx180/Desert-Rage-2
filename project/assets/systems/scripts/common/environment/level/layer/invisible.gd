extends TileMapLayer

@export_range(0, 255, 1) var transparency: int = 1

func _ready() -> void:
	modulate.a8 = transparency
