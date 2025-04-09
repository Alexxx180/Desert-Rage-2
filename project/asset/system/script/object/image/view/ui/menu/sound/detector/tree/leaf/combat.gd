extends HBoxContainer

@onready var content: Dictionary = {
	"ambient": $content/ambient,
	"heating": $content/heating,
	"rampage": $content/rampage
}

var i: int

func set_actions(options: Node, entry: Dictionary, progress: Dictionary) -> void:
	i = entry.i
	for status in content:
		var button: Control = content[status]
		button.pressed.connect(func():
			options.drop.delete_theme(entry)
			options.add.add_fight(entry)
			options.search.search_theme(entry)
			options.play.play_theme(entry, progress)
		)
