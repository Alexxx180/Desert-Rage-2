extends Node

func controls(meta: Dictionary) -> void:
	meta.combo.timer = meta.actions.combo
	meta.combo.query = []
	meta.combo.max = 3
