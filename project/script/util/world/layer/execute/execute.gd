extends TileMapLayer

const MANUAL: int = 1

var books: Dictionary = {}
var dialog: Label:
	get: return Works.pload(self, PreloadBus.dialog, "dialog")

func show_text(map_coords: Vector2i) -> void:
	dialog.position = map_to_local(map_coords + Vector2i(-3, -3))
	dialog.set_text(books[map_coords][MANUAL])
	dialog.show()

func hide_text() -> void: dialog.hide()
