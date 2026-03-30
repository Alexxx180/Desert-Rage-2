extends VBoxContainer

@onready var title: HBoxContainer = $title
@onready var stats: HFlowContainer = $stats

func set_stats(summary: Dictionary, hero: String) -> void: stats.set_stats(summary, hero)

func set_caption(caption: Label) -> void: stats.set_caption(caption)
