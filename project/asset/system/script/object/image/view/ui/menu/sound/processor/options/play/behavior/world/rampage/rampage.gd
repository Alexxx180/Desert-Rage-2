extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = check.rampage
	theme.set_playback(options, progress)
