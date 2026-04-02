extends TileMapLayer

@onready var recovery: Node = $recovery

const MANUAL: int = 1

var books: Dictionary = {}

var _dialog: Label = null
var dialog: Label:
	get:
		if _dialog == null:
			_dialog = preload("res://asset/system/scene/subject/actor/npc/dialog.tscn").instantiate()
			add_child(_dialog)
		return _dialog

func show_text(map_coords: Vector2i) -> void:
	dialog.position = map_to_local(map_coords + Vector2i(-3, -3))
	dialog.set_text(books[map_coords][MANUAL])
	dialog.show()

func hide_text() -> void:
	dialog.hide()
