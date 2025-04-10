extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int:
	set(value): check.rampage = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void: check.caption = name

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.path.push_back(name)
	progress.rampage = check.rampage
	# theme.set_playback(options, progress)
	return SoundtrackSystem.get_value(options.ui, progress.path)

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context.duplicate())
