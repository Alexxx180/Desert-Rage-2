extends BehaviorSequence

@onready var theme: BehaviorSelector = $theme

func set_ost(music: Node, event: int) -> void:
	theme.set_ost(music, event, name)
