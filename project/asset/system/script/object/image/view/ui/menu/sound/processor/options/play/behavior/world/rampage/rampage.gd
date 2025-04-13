extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

func set_ost(music: Node) -> void:
	theme.set_ost(music)
