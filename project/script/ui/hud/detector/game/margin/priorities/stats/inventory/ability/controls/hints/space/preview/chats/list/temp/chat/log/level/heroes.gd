extends PanelContainer

@onready var heroes: HFlowContainer = $margin/hero

func set_priority(level: Node, stats: Dictionary) -> void:
	for hero in heroes.get_children():
		hero.set_priority(level, stats)
