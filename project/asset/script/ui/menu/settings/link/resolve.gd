extends Node

var t: Node

func connects(ui: Button, type: String, mask: int) -> void:
	ui.pressed.connect(t.activate(type, mask))

func logic(caption: String, type: String, mask: int) -> void:
	connects(t.phrase(t.of(caption)), type, mask)

func option(named: String) -> void:
	t.set_title()
	t.set_caption(named)
