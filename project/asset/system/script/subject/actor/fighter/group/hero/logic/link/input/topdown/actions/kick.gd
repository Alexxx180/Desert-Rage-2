extends Node

func controls(meta: Dictionary) -> void:
	var press: Node = meta.act.skills.press
	meta.tools.stomp = { "plate": press.stomp, "box": press.throw }
	meta.actions.board.set_value("kick", { "pressed": false, "toggled": false })
