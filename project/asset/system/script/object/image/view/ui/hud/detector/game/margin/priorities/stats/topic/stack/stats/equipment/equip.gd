extends VBoxContainer

@onready var title: HBoxContainer = $title
#@onready var heroes: HBoxContainer = $heroes
@onready var description: VBoxContainer = $description

@onready var stats: HFlowContainer = $stats
@onready var heroes: Array[VBoxContainer] = [
	$stats/value/heroes/ray, $heroes/value/heroes/rock]
# @onready var description: VBoxContainer = $description

func set_stats(summary: Dictionary, hero: String) -> void:
	heroes[0].set_stats(summary.stats[hero])
# 	heroes[1].set_stats(stats.stats.rock)
	# var summary: Dictionary = level.summary

func connect_description(opened: Button, caption: Label) -> void:
	opened.focus_entered.connect(func(): caption.show())
	opened.focus_exited.connect(func(): caption.hide())
	opened.mouse_entered.connect(func(): caption.show())
	opened.mouse_exited.connect(func(): caption.hide())

func set_caption(caption: Label) -> void:
	connect_description(heroes[0].get_node(NodePath(caption.name)), caption)

"""
func _ready() -> void:
	for caption in description.get_children():
		set_caption(caption)
"""
