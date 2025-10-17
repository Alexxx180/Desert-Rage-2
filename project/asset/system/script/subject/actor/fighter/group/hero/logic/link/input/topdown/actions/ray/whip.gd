extends Node

func controls(meta: Dictionary) -> void:
	if not "whip" in meta.act.ability: return
	meta.tools.pillar = meta.act.ability.whip
	meta.board.set_value("whip", { "pressed": false, "toggled": false })
