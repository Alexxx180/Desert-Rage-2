extends Node

func controls(meta: Dictionary) -> void:
	var press: Node = meta.act.skills.press
	meta.tools.stomp = { "plate": press, "box": press } # TODO FIXME unify stomp logic
	meta.board.s("kick", { "pressed": false, "toggled": false })
